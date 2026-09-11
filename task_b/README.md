# Task B

Companion code for Group 1's "Ada" presentation slides. Each section of
the slides (Exceptions, Low-Level Hardware Modeling, Concurrency,
Subprograms, and the Ravenscar Profile) has a small, runnable example in
`src/`, following the same style as `ada_ex` elsewhere in this repo:
short, heavily-commented demos rather than a single realistic program.

## Programs

- **`task_b`** ([src/task_b.adb](src/task_b.adb)) — one procedure that
  runs through five of the slide topics in order:
  1. **Exceptions** — declaring, raising, and handling a custom
     exception (`My_Error`).
  2. **Low-Level Hardware Modeling** — an enum with an explicit binary
     representation, a bit-packed `Status_Register` record (`for ...
     use record ... at Byte_Offset range First_Bit .. Last_Bit`), and
     both ordinary (`Sensor_Voltage`) and decimal (`Dollars`)
     fixed-point types.
  3. **Concurrency** — an untyped task (`Hello_Task`), a rendezvous
     task with entries (`Counter`), and a protected object with a
     ceiling priority (`Shared_Data`).
  4. **Subprograms** — a nested function/procedure pair, and the three
     parameter modes (`in`, `out`, `in out`).

- **`ravenscar_demo`** ([src/ravenscar_demo.adb](src/ravenscar_demo.adb),
  [src/simple_task_pkg.ads](src/simple_task_pkg.ads)) — the **Ravenscar
  Profile** example lives in its own tiny program because
  `pragma Profile (Ravenscar)` applies to the whole partition and
  restricts tasking (tasks must be declared at library level, no
  `select`, only one entry per task). Those restrictions conflict with
  `task_b`'s `Counter` task, so the profile is demonstrated separately:
  a single library-level task with a ceiling priority, started
  automatically and waited on by an otherwise-empty main procedure.

## Running

From this directory:

```sh
alr build
alr run task_b
alr run ravenscar_demo
```

(or run the built binaries directly: `./bin/task_b`, `./bin/ravenscar_demo`)

## Expected output

```
$ alr run task_b
Hello World! from Hello_Task
== 01. Exceptions ==
Caught My_Error -> Something went wrong in Show_Exceptions
== 02. Low-Level Hardware Modeling ==
Status_Register'Size =  8
Status.Mode = FAST, Status.Speed =  5
Sensor_Voltage reading =  3.28
Dollars price =  19.99
== 03. Concurrency ==
Counter.Get ->  3
Shared_Data.Read ->  42
== 04. Subprograms ==
 4 is even
 7 is odd
Show_Number(in) ->  3
Get_Number(out) ->  20
Add_Five(in out) ->  25

$ alr run ravenscar_demo
Hello from a Ravenscar-compliant task!
```

`Hello_Task` prints on its own schedule as soon as it's elaborated, so it
can appear before or interleaved with the "== 01. ... ==" lines above —
that's expected task-scheduling behavior, not a bug.

`Sensor_Voltage`'s printed value (`3.28` above) may vary slightly by
compiler/run: ordinary fixed-point types store values as an integer
multiple of an implementation-chosen `Small` (GNAT picks the largest
power of two ≤ the declared `delta`), so a decimal literal like `3.30`
isn't always represented exactly.
