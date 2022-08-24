import asyncio
import bleak
from bleak import BleakScanner, BleakClient, discover
import numpy as np
import time
import os
from ahrs.filters import Madgwick
import math as m

RAW_DATA_UUID = "00000002-0000-1000-8000-00805f9b34fb"

previous_time = time.time()
madgwick = Madgwick()
madgwick.gain = 0.1
Q = [1,0,0,0]

DEG_TO_RAD = m.pi/180
RAD_TO_DEG = 1/DEG_TO_RAD
GRAVITATIONAL_ACCEL = 9.8106

ROS_VISUALIZATION = False
if ROS_VISUALIZATION:
    import rospy
    import tf2_ros
    from geometry_msgs.msg import TransformStamped

connected = False
def quaternion_rotation_matrix(Q):
    """
    Covert a quaternion into a full three-dimensional rotation matrix.
 
    Input
    :param Q: A 4 element array representing the quaternion (q0,q1,q2,q3) 
 
    Output
    :return: A 3x3 element matrix representing the full 3D rotation matrix. 
             This rotation matrix converts a point in the local reference 
             frame to a point in the global reference frame.
    """
    # Extract the values from Q
    q0 = Q[0]
    q1 = Q[1]
    q2 = Q[2]
    q3 = Q[3]
     
    # First row of the rotation matrix
    r00 = 2 * (q0 * q0 + q1 * q1) - 1
    r01 = 2 * (q1 * q2 - q0 * q3)
    r02 = 2 * (q1 * q3 + q0 * q2)
     
    # Second row of the rotation matrix
    r10 = 2 * (q1 * q2 + q0 * q3)
    r11 = 2 * (q0 * q0 + q2 * q2) - 1
    r12 = 2 * (q2 * q3 - q0 * q1)
     
    # Third row of the rotation matrix
    r20 = 2 * (q1 * q3 - q0 * q2)
    r21 = 2 * (q2 * q3 + q0 * q1)
    r22 = 2 * (q0 * q0 + q3 * q3) - 1
     
    # 3x3 rotation matrix
    rot_matrix = np.array([[r00, r01, r02],
                           [r10, r11, r12],
                           [r20, r21, r22]])
                            
    return rot_matrix

def ToEulerAngles(Q):
    w, x, y, z = Q
    angles = {"yaw":0, "pitch":0, "roll":0}

    #roll (x-axis rotation)
    sinr_cosp = 2 * (w * x + y * z)
    cosr_cosp = 1 - 2 * (x * x + y * y)
    angles["roll"] = m.atan2(sinr_cosp, cosr_cosp)

    #pitch (y-axis rotation)
    sinp = 2 * (w * y - z * x);
    if abs(sinp) >= 1:
        angles["pitch"] = m.copysign(M_PI / 2, sinp)# use 90 degrees if out of range
    else:
        angles["pitch"] = m.asin(sinp)

    # yaw (z-axis rotation)
    siny_cosp = 2 * (w * z + x * y)
    cosy_cosp = 1 - 2 * (y * y + z * z)
    angles["yaw"] = m.atan2(siny_cosp, cosy_cosp)

    return angles

def callback(sender: int, data: bytearray):
    global previous_time
    global madgwick
    global Q
    # if sender != 21:
    #     print(sender, len(data))
    #     try:
    #         with open(f"{sender}.bin", "xb") as f:
    #             f.write(data)
    #     except:
    #         pass
    if sender == 21:
        t = time.time()
        dt = t-previous_time
        previous_time = t
        print()
        print()
        # print(1/dt)
        raw_data = np.frombuffer(data, dtype=np.dtype("<i2"), offset=7).reshape((6,20))
        gyro = raw_data[0:3,:] * (250/2**15/8*2/3)
        accel = raw_data[3:6,:] * (2/2**15) #2g per 32k
        madgwick.Dt = dt
        for i in range(20):
            Q = madgwick.updateIMU(Q, gyro[:,i]*DEG_TO_RAD, accel[:,i]*GRAVITATIONAL_ACCEL)
        # print(gyro)
        
        ypr = ToEulerAngles(Q)
        rot_mat = np.array(quaternion_rotation_matrix(Q))
        removed = accel[:,0:1]*GRAVITATIONAL_ACCEL - np.matmul(np.linalg.inv(rot_mat),np.array([[0],[0],[GRAVITATIONAL_ACCEL]]))
        length = (removed[0][0]**2 + removed[1][0]**2 + removed[2][0]**2)**1/2
        print("accel: {:10.5f}".format(length))
        # print("{:10.3f}".format(np.average(gyro[2])*(60/360)))
        print("yaw:   {:5.2f}".format(ypr["yaw"]*RAD_TO_DEG))
        print("pitch: {:5.2f}".format(ypr["pitch"]*RAD_TO_DEG))
        print("roll:  {:5.2f}".format(ypr["roll"]*RAD_TO_DEG))
        print(Q)
        if ROS_VISUALIZATION:
            transform = TransformStamped()
            transform.header.frame_id = "odom"
            transform.header.stamp = rospy.Time.now()
            transform.child_frame_id = "canik"
            transform.transform.translation.z = 1
            transform.transform.rotation.w = Q[0]
            transform.transform.rotation.x = Q[1]
            transform.transform.rotation.y = Q[2]
            transform.transform.rotation.z = Q[3]
            tf2_ros.TransformBroadcaster().sendTransform(transform)

async def main():
    global connected
    if ROS_VISUALIZATION:
        rospy.init_node("canik")
    while True:
        if connected:
            await asyncio.sleep(100)
        print()
        devices = await discover()
        caniks = []
        for d in devices:
            try:
                if d.name.strip() == 'MyCanik':
                    print(f'found canik')
                    caniks.append(d)
            except Exception as e:
                pass
        print(f'found {len(caniks)} caniks.')
        for i, canik in enumerate(caniks):
            print(f'connecting to canik {i} at address {canik.address}')
            if connected:
                break
            connected = await connect(canik.address)
            if connected:
                break


async def connect(address)->bool:
    try:
        client = BleakClient(address)
        if not await client.connect():
            return False
        print('connected')
        services = await client.get_services()
        print('found ' + str(len(services.services.keys())) + ' services')

        for service in services.services.values():
            for characteristic in service.characteristics:
                try:
                    # if str(characteristic.uuid) == RAW_DATA_UUID:
                    print(service.description, characteristic.uuid, characteristic.handle)
                    await client.start_notify(characteristic.uuid, callback)
                except bleak.exc.BleakDBusError as dbe:
                    print(dbe)
                    continue
                except Exception as e:
                    print(e)
                    continue
        return True
    except Exception as e:
        print(e)
        return False


if __name__ == '__main__':
    asyncio.run(main())
