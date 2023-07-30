def average(*num):
    Sum = 0
    for i in range(len(num)):
        Sum += num[i]
    return Sum/len(num)

def sum(*num):
    Sum = 0
    for i in range(len(num)):
        Sum += num[i]
    return Sum