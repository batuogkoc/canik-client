import string


with open('data.bin', 'rb') as f:
    raw_data = f.read(-1)
    raw_data = bytearray(b".!\x00 \xde\x0e\x16\x99\x01W\x01!\x01\xcc\x00Z\x00\t\x00\xbb\xffb\xff\xe0\xfeQ\xfe\xcb\xfde\xfd\xfe\xfc\x9d\xfc%\xfc\xe2\xfb\xb3\xfb\x86\xfb\x82\xfbe\xfb1\xffI\xff8\xff\'\xff/\xff)\xff \xff\x16\xff\x1d\xff\x0b\xff\x15\xff\x1d\xff$\xff.\xffF\xffM\xffh\xff\x83\xff\xaf\xff\xc9\xffJ\x01\x19\x01\xf3\x00\xd0\x00\x9b\x00Z\x00\x1b\x00\xcd\xff\x88\xff9\xff\xf3\xfe\xad\xfeS\xfe\xff\xfd\xbd\xfdf\xfd\x13\xfd\xcf\xfc\x8e\xfc\\\xfc\x18\xcb(\xcb7\xcbL\xcbH\xcb`\xcbk\xcb\x96\xcb\x94\xcb\xcb\xcb\xe2\xcb\xd4\xcb\xe8\xcb\x0f\xcc*\xcc1\xcc%\xcc.\xcc\x18\xcc\xfd\xcb\xa7\n\xb8\n\xab\n\xcc\n\xf0\n\xf8\n\x1b\x0b\r\x0b\x01\x0b\xfc\n\xff\n\xf7\n\n\x0b\xce\n\xaf\n\xa2\n\\\nf\nI\n\x18\n\xf1#\x13$\x16$\xf4#;$2$q$\x8a$\x9e$\xb3$\xf6$@%a%m%\x9e%\xe8%\r&2&^&^&")
    print(len(raw_data))
    data = [[] for i in range(6)]
    for i in range(6*20):
        data[i//(20)].append(int.from_bytes(raw_data[7+i*2:7+i*2+1], 'little', signed=True))
    print(data)
with open('processed-data.txt', 'w') as fl:
    for i in data:
        fl.write('\n')
        for j in i:
            fl.write(str(j) + ' ')


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                import string


with open('data.bin', 'rb') as f:
    raw_data = f.read(-1)
    raw_data = bytearray(b".!\x00 \xde\x0e\x16\x99\x01W\x01!\x01\xcc\x00Z\x00\t\x00\xbb\xffb\xff\xe0\xfeQ\xfe\xcb\xfde\xfd\xfe\xfc\x9d\xfc%\xfc\xe2\xfb\xb3\xfb\x86\xfb\x82\xfbe\xfb1\xffI\xff8\xff\'\xff/\xff)\xff \xff\x16\xff\x1d\xff\x0b\xff\x15\xff\x1d\xff$\xff.\xffF\xffM\xffh\xff\x83\xff\xaf\xff\xc9\xffJ\x01\x19\x01\xf3\x00\xd0\x00\x9b\x00Z\x00\x1b\x00\xcd\xff\x88\xff9\xff\xf3\xfe\xad\xfeS\xfe\xff\xfd\xbd\xfdf\xfd\x13\xfd\xcf\xfc\x8e\xfc\\\xfc\x18\xcb(\xcb7\xcbL\xcbH\xcb`\xcbk\xcb\x96\xcb\x94\xcb\xcb\xcb\xe2\xcb\xd4\xcb\xe8\xcb\x0f\xcc*\xcc1\xcc%\xcc.\xcc\x18\xcc\xfd\xcb\xa7\n\xb8\n\xab\n\xcc\n\xf0\n\xf8\n\x1b\x0b\r\x0b\x01\x0b\xfc\n\xff\n\xf7\n\n\x0b\xce\n\xaf\n\xa2\n\\\nf\nI\n\x18\n\xf1#\x13$\x16$\xf4#;$2$q$\x8a$\x9e$\xb3$\xf6$@%a%m%\x9e%\xe8%\r&2&^&^&")
    print(len(raw_data))
    data = [[] for i in range(6)]
    for i in range(6*20):
        data[i//(20)].append(int.from_bytes(raw_data[7+i*2:7+i*2+1], 'little', signed=True))
    print(data)
with open('processed-data.txt', 'w') as fl:
    for i in data:
        fl.write('\n')
        for j in i:
            fl.write(str(j) + ' ')


