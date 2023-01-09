from machine import Pin, UART, I2C, Timer
import time
from imu import MPU6050
import math

# Setup para Pisca-Pisca
led = Pin(25, Pin.OUT)
timer = Timer()


# Parameterização dos Protocolos
# I2C
i2c = I2C(1, sda=Pin(2), scl=Pin(3), freq=400000) # bloco 1, pinos 2 e 3 dos disponíveis para i2c
imu = MPU6050(i2c)
# UART
uart = UART(1,9600)


# Pisca OnBoard
# Função para fazer toggle do led
def setup_pisca_pisca(timer):
    led.toggle()
# Função para piscar o led periodicamente
def pisca_pisca():
    timer.init(freq=2.5, mode=Timer.PERIODIC, callback=setup_pisca_pisca(timer))


# Leitura dos dados do acelerómetro
def ler_acelerometro():
    # print dos valores sem formatação
    # print(imu.accel.xyz,imu.gyro.xyz,imu.temperature,end='\r')
    ax=round(imu.accel.x,2)
    ay=round(imu.accel.y,2)
    az=round(imu.accel.z,2)
    #gx=round(imu.gyro.x)
    #gy=round(imu.gyro.y)
    #gz=round(imu.gyro.z)
    #tem=round(imu.temperature,2)
    #print(ax,"\t",ay,"\t",az,"\t",gx,"\t",gy,"\t",gz,"\t",tem,"        ",end="\r")

    time.sleep(0.5)
    acel=math.sqrt(ax**2+ay**2+az**2)*10000
    print("Float:",acel)

    dados = str(acel)
    print("String:", dados)

    leitura_bluetooth(dados)


# Leitura dos dados do módulo bluetooth
def leitura_bluetooth(dados):
    #while True:
    if uart.any():
        #uart.write(b"ABC")
        print(dados)
        uart.write(dados + "\n")

        #data = uart.readline()
        #print(data)
        """if data== b'0':
            uart.sendbreak()
            #led.high()
            #print("LED is now ON!")
        elif data== b'0':
            led.low()
            print("LED is now OFF!")"""


# Loop Principal
while True:
    #pisca_pisca()
    ler_acelerometro()
    #leitura_bluetooth()
