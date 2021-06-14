import time
if __name__ == "__main__":
    x = 0
    while( x < 10 ):
        time.sleep(30)
        print(f"still alive{x}")
        x = x + 1
