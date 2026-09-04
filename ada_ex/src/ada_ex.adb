-- Packages
with Ada.Text_IO; -- Text Package
with Ada.Command_Line; -- Command Line Package
with Ada.Real_Time; -- Real Time Package
with Ada.Calendar; -- Calendar Package
with Ada.Calendar.Formatting;
with hello; -- Import the hello procedure from hello.adb
with Ada.Command_Line; -- Command Line Package

procedure Ada_Ex is

   -- Variables
   -- var syntax: var_name : var_type := value;
   HelloWorld : String := "HELLO World!";
   x : Integer := 1; 
   -- Something like HelloWorld : Integer := "Hello World!"; will not work because the type of the variable is integer and the value is a string. Showing how Ada is a strongly typed language.
-- Variables
-- var syntax: var_name : var_type := value;
HelloWorld : String :="HELLO World!";
x : Integer := 1;

-- Functions
-- A function always returns a value.
-- syntax: function Name (Param : Type) return Return_Type is ... begin ... return ...; end Name;

-- Simple function: adds two integers and returns the result.
function Add (A : Integer; B : Integer) return Integer is
begin
   return A + B;
end Add;

-- Function with a local variable: computes the square of a number.
function Square (N : Integer) return Integer is
   Result : Integer := N * N;
begin
   return Result;
end Square;

-- Function returning a String: builds a greeting.
function Greet (Name : String) return String is
begin
   return "Hello, " & Name & "!";
end Greet;

-- Function with a default parameter value.
-- If the caller omits Step, it defaults to 1.
function Increment (Value : Integer; Step : Integer := 1) return Integer is
begin
   return Value + Step;
end Increment;

   -- Real-Time Delay
   Time_1 : Ada.Calendar.Time;
   Time_2 : Ada.Calendar.Time;
   Next_Time : Ada.Real_Time.Time;
   
   -- range contraints
   y : Integer range 1 .. 10 := 5; -- variable y is constrained to be between 1 and 10, inclusive

   -- Tasks example
   task Hello_Task;
   task Goodbye_Task;

   task body Hello_Task is
   begin
      Ada.Text_IO.Put_Line ("Hello World! from Hello_Task");
   end Hello_Task;

   task body Goodbye_Task is
   begin
      Ada.Text_IO.Put_Line ("Goodbye World! from Goodbye_Task");
   end Goodbye_Task;

begin
   -- Hello World
   Ada.Text_IO.Put_Line ("Hello Word!");
   -- With Var
   Ada.Text_IO.Put_Line (HelloWorld);

   -- For Loop
   -- Loop over each command-line argument and print it.
   for NEXT in 1 .. Ada.Command_Line.Argument_Count loop
      -- A declare block gives us a place to declare per-iteration variables.
      declare
         VALUE : String := Ada.Command_Line.Argument (NEXT);
      begin
         Ada.Text_IO.Put_Line (Integer'Image (NEXT) & ": " & VALUE);
      end;
   end loop;


   -- Schedule the next execution exactly 5 second from
   -- the previous scheduled execution.

   Time_1 := Ada.Calendar.Clock; -- Get the current time before the delay
   Ada.Text_IO.Put_Line ("Hello World! First " & Ada.Calendar.Formatting.Image (Time_1));
   -- Wait until the scheduled time
   Next_Time := Ada.Real_Time."+"(Ada.Real_Time.Clock, Ada.Real_Time.Seconds (5)); -- Schedule the next execution exactly 5 seconds from now
   delay until Next_Time; -- Wait until the scheduled time
   Time_2 := Ada.Calendar.Clock; -- Get the current time after the delay
   Ada.Text_IO.Put_Line ("Hello World! Second " & Ada.Calendar.Formatting.Image (Time_2));


   -- Range Constraint Example
   Ada.Text_IO.Put_Line ("The value of y is: " & Integer'Image(y));


   -- procedure call example
   hello; -- Call the hello procedure from hello.adb



-- exception handling example
   Ada.Text_IO.Put_Line
     ("Argument: " & Ada.Command_Line.Argument (1));



exception

   when Constraint_Error =>
      Ada.Text_IO.Put_Line ("Invalid command-line argument.");


Ada.Text_IO.Put_Line(Integer'Image (x));

-- Calling the functions
-- Add two numbers.
Ada.Text_IO.Put_Line ("Add(2, 3) =" & Integer'Image (Add (2, 3)));

-- Square a number.
Ada.Text_IO.Put_Line ("Square(5) =" & Integer'Image (Square (5)));

-- Greet by name (String-returning function).
Ada.Text_IO.Put_Line (Greet ("Ada"));

-- Increment using the default step (1).
Ada.Text_IO.Put_Line ("Increment(10) =" & Integer'Image (Increment (10)));

-- Increment with an explicit step.
Ada.Text_IO.Put_Line ("Increment(10, 5) =" & Integer'Image (Increment (10, 5)));
end Ada_Ex;