# Wireframe Renderer for the Z80




Allows you to display "any" 3D objekt on screen, you just have to figure out how to generate the verticies and faces.


## Features

- Customizable rotation speed

- Customizable distance to the camera

- Customizable Color

- Customizable Draw thickness





## Compile

You'll have to understand the whole Zeal-8-Bit Projekt, but i assume u do:
```
 export ZGDK_PATH=/your/path/to/zeal-game-development-kit
 make
```
## Developent

It's my first big C projekt, so i'm having a hard time but none or less i have found some cool optimations such as:

- Using a lut(look up table) for cos and sin
- Using a DRM to clear the screen
- Using a smart 3D Modell

My biggest Problems so far where:
- Wrong LUT
- Lack of clamp_proj

## Final
Feel free to to do whatever you wan't with the code or give tipps for improvment.
Big thanks to Zoding(https://www.youtube.com/@TsodingDaily) for the whole rendering logic.

## Images

![image](images/1.png)
![image](images/2.png)
![image](images/3.png)
![image](images/4.png)
