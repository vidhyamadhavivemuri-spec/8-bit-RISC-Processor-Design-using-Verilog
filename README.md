# Microcontroller Register Simulator

A modular **Embedded C-based microcontroller register and peripheral simulator** that models register-level operations, peripheral behavior, interrupt handling, event processing, system states, and application-level responses without requiring physical hardware.

The project is structured to reflect the layered architecture commonly used in embedded software, with independent modules for registers, peripherals, interrupts, events, application logic, system state, and outputs.

---

## Overview

The simulator models microcontroller hardware behavior using C variables as simulated registers and dedicated software modules for individual peripherals.

The overall architecture is:

```text
Registers
    ↓
Peripherals
    ↓
Interrupt Controller
    ↓
Events
    ↓
Application
    ↓
System State
    ↓
Alert Output
```

Each layer has a defined responsibility, allowing the system to be developed, tested, and extended in a modular manner.

---

## Features

### Register-Level Simulation

The project provides simulated hardware registers for peripheral control and status.

Key concepts include:

* Register-level programming
* Memory-mapped I/O concepts
* Fixed-width integer types
* Register status and control fields
* Bitwise operations
* Bit masks
* Bit setting, clearing, and toggling
* `extern` declarations for shared registers

---

## Supported Peripherals

The simulator currently implements the following peripheral modules:

### GPIO

Supports:

* GPIO output register simulation
* Pin set operation
* Pin clear operation
* Pin toggle operation
* Pin read operation
* Pin validation
* 32-bit register behavior

### UART

Supports:

* Transmit-ready status
* Transmit data handling
* Transmission state
* Automatic transmission completion
* Receive status
* UART data register simulation

### Timer

Supports:

* Timer start and stop
* Counter updates
* Overflow detection
* Overflow status
* Sticky overflow behavior
* Timer interrupt generation

### ADC

Supports:

* ADC conversion control
* Conversion completion
* ADC data register
* ADC value range handling
* ADC data reading
* ADC interrupt generation

### PWM

Supports:

* PWM enable and disable
* Duty-cycle configuration
* Duty-cycle range validation

### SPI

Supports:

* SPI enable and disable
* Transmit-ready status
* Data transmission
* Receive data handling
* Receive status
* Busy-state behavior
* Data overwrite handling

### I2C

Supports:

* I2C enable and disable
* Address configuration
* Start and stop operations
* Bus busy state
* Data transmission
* Data reception
* Receive status
* Address validation

### Watchdog Timer

Supports:

* Watchdog enable and disable
* Watchdog timeout configuration
* Watchdog counter
* Watchdog feeding
* Timeout detection
* Timeout status
* INT2 generation
* Zero-timeout handling
* Sticky timeout status

---

# Interrupt Controller

The interrupt controller provides a centralized mechanism for handling peripheral-generated interrupts.

The simulator supports:

```text
INT0
INT1
INT2
```

Features include:

* Interrupt enable and disable
* Interrupt triggering
* Pending interrupt status
* Interrupt clearing
* Interrupt handler registration
* Interrupt servicing
* Interrupt priority
* Next-pending-interrupt servicing

Interrupt handlers are implemented using function pointers, allowing peripheral events to be connected to appropriate handlers.

---

# Event-Driven Architecture

Peripheral interrupts are converted into application-level events instead of directly controlling application behavior.

The event layer currently supports:

```text
Timer Event
ADC Event
WDT Event
Alert Event
```

The general flow is:

```text
Peripheral
    ↓
Interrupt
    ↓
Interrupt Handler
    ↓
Event
    ↓
Application
```

This separates low-level interrupt handling from higher-level application processing.

---

# Application Layer

The application layer processes pending events and determines the resulting system behavior.

The application maintains:

* Timer event count
* WDT event count
* Last ADC value
* ADC state
* Alert status
* Alert output status

The application also coordinates the interaction between peripheral events and the system state.

---

# System State Management

The system state module maintains the overall operating state of the simulator.

Three system states are currently defined:

```text
SYSTEM_INIT
SYSTEM_RUNNING
SYSTEM_ALERT
```

The state flow is:

```text
SYSTEM_INIT
      ↓
SYSTEM_RUNNING
      ↓
SYSTEM_ALERT
```

The application layer is responsible for transitioning the system into an alert state when appropriate events are processed.

---

# Alert Output

The alert output module provides an independent interface for controlling the system's alert output.

It supports:

* Alert output initialization
* Alert output ON
* Alert output OFF
* Alert output status checking

The application layer determines when the alert output should be activated.

---

# Watchdog Timer Integration

The Watchdog Timer demonstrates the complete peripheral-to-application event flow.

When the watchdog reaches its configured timeout:

```text
WDT
 ↓
Timeout
 ↓
INT2
 ↓
Interrupt Handler
 ↓
WDT Event
 ↓
Application
 ↓
SYSTEM_ALERT
```

The WDT itself is responsible for detecting the timeout and generating INT2.

The interrupt handler converts the interrupt into a WDT event.

The application processes the event and changes the system state to `SYSTEM_ALERT`.

This keeps the WDT, interrupt controller, event system, and application logic independent.

---

# ADC Alert Integration

The ADC is integrated into the interrupt and application layers.

For example, when an ADC conversion produces a value of `800`:

```text
ADC Conversion
      ↓
ADC Interrupt
      ↓
ADC Event
      ↓
Application reads ADC value
      ↓
ADC_ALERT
      ↓
Alert Event
      ↓
SYSTEM_ALERT
      ↓
Alert Output ON
```

This demonstrates the complete flow from peripheral activity to application-level system response.

---

# Project Architecture

The project follows a layered modular architecture:

```text
                    ┌─────────────────────┐
                    │      Registers      │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │     Peripherals     │
                    │ GPIO / UART / ADC   │
                    │ Timer / PWM / SPI   │
                    │ I2C / WDT           │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │ Interrupt Controller│
                    │      INT0/1/2       │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │       Events        │
                    │ Timer / ADC / WDT   │
                    │       / Alert       │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │     Application     │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │    System State     │
                    │ INIT/RUNNING/ALERT  │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │    Alert Output     │
                    └─────────────────────┘
```

---

# Project Structure

```text
microcontroller-register-simulator/
│
├── include/
│   ├── adc.h
│   ├── alert_output.h
│   ├── application.h
│   ├── events.h
│   ├── gpio.h
│   ├── interrupt.h
│   ├── i2c.h
│   ├── pwm.h
│   ├── register.h
│   ├── spi.h
│   ├── system.h
│   ├── timer.h
│   ├── uart.h
│   └── wdt.h
│
├── src/
│   ├── adc.c
│   ├── alert_output.c
│   ├── application.c
│   ├── events.c
│   ├── gpio.c
│   ├── interrupt.c
│   ├── main.c
│   ├── pwm.c
│   ├── register.c
│   ├── spi.c
│   ├── system.c
│   ├── timer.c
│   ├── uart.c
│   └── wdt.c
│
├── tests/
│   ├── test_adc.c
│   ├── test_adc_interrupt.c
│   ├── test_alert_output.c
│   ├── test_application.c
│   ├── test_application_wdt.c
│   ├── test_events_wdt.c
│   ├── test_gpio.c
│   ├── test_i2c.c
│   ├── test_interrupt_handlers.c
│   ├── test_interrupt_int2.c
│   ├── test_interrupt_priority.c
│   ├── test_peripheral_interrupts.c
│   ├── test_pwm.c
│   ├── test_spi.c
│   ├── test_system.c
│   ├── test_timer.c
│   ├── test_uart.c
│   ├── test_wdt.c
│   ├── test_wdt_application_integration.c
│   └── test_wdt_interrupt_event.c
│
├── diagrams/
├── docs/
├── examples/
├── .gitignore
├── LICENSE
└── README.md
```

---

# Build

The project uses **GCC** and the **C11 standard**.

From the project root:

```bash
gcc -Wall -Wextra -std=c11 \
src/main.c \
src/register.c \
src/timer.c \
src/adc.c \
src/interrupt.c \
src/events.c \
src/application.c \
src/alert_output.c \
src/system.c \
src/wdt.c \
-Iinclude \
-o simulator
```

Run the simulator:

```bash
./simulator
```

---

# Testing

The project includes standalone module tests and integration tests.

The complete regression suite contains **20 test programs** covering:

* ADC
* ADC → INT1 integration
* Alert output
* Application event processing
* WDT application events
* WDT events
* GPIO
* I2C
* Interrupt handlers
* INT2
* Interrupt priority
* Peripheral interrupt integration
* PWM
* SPI
* System state
* Timer
* UART
* Watchdog Timer
* WDT → Application integration
* WDT → INT2 → Event integration

The full simulator has also been compiled using:


-Wall -Wextra -std=c11


and executed successfully.

The complete regression run completed successfully with all **20 test executables passing**.

---

# Embedded C Concepts

The implementation demonstrates practical use of:

* Modular C programming
* Header and source file separation
* Function prototypes
* `extern` declarations
* Global variables
* `static` module-level variables
* Fixed-width integer types
* Bitwise operators
* Bit masks
* Register manipulation
* Memory-mapped I/O concepts
* Function pointers
* Interrupt handlers
* Event-driven architecture
* Peripheral abstraction
* Application-layer processing
* State-machine concepts
* Unit testing
* Integration testing
* Defensive input validation

---

# Design Principles

The project follows several principles commonly used in embedded software development.

### Modular Design

Each peripheral and software layer is implemented as an independent module.

### Separation of Responsibilities

Low-level hardware simulation, interrupt handling, event processing, and application logic are kept separate.

### Event-Driven Processing

Interrupt handlers generate events, while the application processes those events separately.

### Testability

Individual modules can be tested independently, while integration tests verify communication between multiple layers.

### Controlled Interfaces

Header files expose module interfaces while implementation details remain inside the corresponding source files.

---

# Verification

The final implementation has been verified through:

* Individual peripheral tests
* Interrupt controller tests
* Interrupt handler tests
* Peripheral interrupt integration tests
* Application-level tests
* WDT integration tests
* System state tests
* Alert output tests
* Full simulator execution
* Full regression testing


---

# Status

**Completed**

The core register, peripheral, interrupt, event, application, system-state, and alert-output layers have been implemented and integrated.

The simulator currently provides a complete software flow from simulated hardware activity to application-level system response.

---

# Author

**Vemuri Vidhya Madhavi**

Electronics and Telematics Engineering
