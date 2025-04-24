import random

def write_mem_hex(filepath, data_list):
    with open(filepath, 'w') as f:
        for val in data_list:
            f.write(f"{val:08x}\n")

def main():
    data_mem = [random.randint(0, 0xFFFFFFFF) for _ in range(256)]
    write_mem_hex("./mem/dmem.hex", data_mem)
    print("✅ Generated dmem.hex with 256 random 32-bit values.")

if __name__ == "__main__":
    main()
