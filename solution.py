def convert_minutes(n):
    hrs = n // 60
    mins = n % 60
    if hrs == 0:
        return f"{mins} minutes"
    elif mins == 0:
        return f"{hrs} hrs"
    else:
        return f"{hrs} hrs {mins} minutes"


def remove_duplicates(s):
    result = ""
    for ch in s:
        if ch not in result:
            result += ch
    return result 


if __name__ == "__main__":
    print(convert_minutes(130))
    print(convert_minutes(110))

    print(remove_duplicates("programming"))