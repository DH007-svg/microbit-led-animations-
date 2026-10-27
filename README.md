# Micro:bit LED Animation Project

An ARM Assembly-based LED animation project for the BBC micro:bit, developed as part of the **Computer Architecture** course.

## 📌 Project Overview

This project displays five animated patterns on the micro:bit's 5×5 LED matrix. Users can switch between animations using the onboard buttons: Button A selects the previous pattern, while Button B selects the next pattern.

The project uses ARM Thumb Assembly to control GPIO pins and the LED matrix directly, without relying on Python or C for the animation logic.

## ✨ Features

- Five animated LED patterns, each consisting of four frames.
- Button A to switch to the previous animation.
- Button B to switch to the next animation.
- GPIO-based LED matrix control.
- LED multiplexing for displaying the 5×5 matrix.
- Button press detection and debouncing.
- Boundary handling to prevent switching beyond the first and last patterns.

## 🎨 LED Animations

The project implements the following five animations:

| No. | Pattern | Description |
|---|---|---|
| 1 | Expanding Square | A central dot expands into a square and contracts. |
| 2 | Horizontal Scan Line | A row of LEDs moves across the display. |
| 3 | Spinning Line | A line changes orientation across successive frames. |
| 4 | Beating Heart | A heart shape pulses between different frames. |
| 5 | Raindrop | A dot moves downward across the LED matrix. |

## ⚙️ Technical Implementation

### 1. LED Matrix Multiplexing

The micro:bit's 5×5 LED matrix is controlled through five row connections and five column connections. The program scans the rows rapidly, updating the column signals for each row. This technique is called **multiplexing** and allows the display to appear continuously illuminated.

### 2. Animation Data

Each pattern contains four frames, with five bytes per frame. The animation data is stored in memory as byte values, with each byte representing the LED configuration for one row.

### 3. Button Input

- **Button A:** Moves to the previous animation.
- **Button B:** Moves to the next animation.

The program reads the GPIO input registers and detects new button presses by comparing the current button state with the previous state.

### 4. Debouncing

Mechanical buttons can produce multiple rapid electrical transitions during a single press. The program uses a delay and button-state tracking to reduce unintended repeated pattern changes.

### 5. ARM Thumb Assembly

The program uses ARM Thumb instructions, registers, memory addressing, bitwise operations, shifts, and addition to calculate animation data addresses and control the LED display.

## 🛠️ Technologies and Concepts

- ARM Thumb Assembly
- BBC micro:bit
- GPIO register programming
- LED matrix multiplexing
- Memory addressing and register management
- Bitwise operations and shift instructions
- Button input handling and debouncing
- Low-level hardware control

## 📂 Project Structure

```text
microbit-led-animations/
├── Microbit_code.S
├── README.md
└── demo.mp4
```

The structure above is a suggested layout. Include any additional assembly source files, startup code, linker configuration, or support routines required by your build environment.

## 🚀 Getting Started

### Prerequisites

- A compatible BBC micro:bit board and its supported hardware revision.
- An ARM assembler and the appropriate toolchain.
- Startup code, linker configuration, and supporting routines required by the project.
- A way to flash the compiled firmware to the board.

### Build and Run

1. Clone or download this repository.
2. Set up the appropriate ARM toolchain and micro:bit development environment.
3. Include the project source files and the required supporting routines.
4. Assemble and link the program using the configuration appropriate for your board.
5. Flash the resulting firmware to the micro:bit.
6. Observe the LED animations and use Buttons A and B to switch between patterns.

**Note:** Exact build commands are not included because the required toolchain, startup files, linker configuration, and flashing procedure depend on the development environment.

## 🐛 Challenges and Solutions

- **Inverted LED output:** Accounted for the active-low column signals by inverting the LED pattern bits before writing them to the GPIO pins.
- **Incorrect animation frames:** Preserved the frame index in a register across function calls to prevent it from being overwritten.
- **Multiple pattern changes per press:** Added button-state tracking and a debounce delay.
- **Pattern address calculation:** Used shift and addition instructions to calculate memory offsets without relying on multiplication by constants.

## 🔮 Future Improvements

- Add more LED animation patterns.
- Replace software delay loops with hardware timers.
- Use the accelerometer to control animations through movement.
- Add animation speed controls.
- Support custom patterns through Bluetooth or serial communication.

## 👥 Team Members

Developed as part of the Computer Architecture course.

- **Kshitij Pachpande** — BC2025049
- **Dhyan Patel** — BC2025072
- **Rushil Parikh** — IC2025025
- **Lakshya Raval** — BC2025054

## 🎓 Learning Outcomes

This project provided practical experience with low-level programming, ARM Assembly, GPIO control, memory addressing, LED multiplexing, and hardware input handling. It also strengthened debugging skills related to register preservation, active-low signals, and mechanical button behavior.

## 📄 Project Report

The detailed project report can be added to this repository as `Microbit_Project_Report.pdf` so that readers can explore the implementation, challenges, and results.

---

*Developed for educational purposes as part of the Computer Architecture course.*
