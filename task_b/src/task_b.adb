--  Configuration pragma: must appear before the context clauses.
--  Required so the protected object below can use Ceiling Priority
--  Locking (see slide "Ceiling Priority").
pragma Locking_Policy (Ceiling_Locking);

--  Packages
with Ada.Text_IO;      --  Text Package
with Ada.Exceptions;   --  Lets us read the message carried by an exception

procedure Task_B is

   ------------------------------------------------------------------
   --  01. Exceptions
   ------------------------------------------------------------------
   --  Exceptions are declared like objects, not like types.
   My_Error : exception;

   procedure Show_Exceptions is
   begin
      raise My_Error with "Something went wrong in Show_Exceptions";
   exception
      --  "E" captures the occurrence so we can read its message.
      when E : My_Error =>
         Ada.Text_IO.Put_Line
           ("Caught My_Error -> " & Ada.Exceptions.Exception_Message (E));
   end Show_Exceptions;

   ------------------------------------------------------------------
   --  02. Low-Level Hardware Modeling
   ------------------------------------------------------------------

   --  Exact Bit Layouts --------------------------------------------
   --  Custom enumeration with an explicit binary representation.
   type Mode_Type is (Stop, Normal, Fast, Turbo);
   for Mode_Type use
     (Stop => 2#00#, Normal => 2#01#, Fast => 2#10#, Turbo => 2#11#);
   for Mode_Type'Size use 2;

   type Speed_Range is range 0 .. 15;
   for Speed_Range'Size use 4;

   --  An 8-bit device status register, laid out bit-by-bit.
   type Status_Register is record
      Power_On : Boolean;      --  1 bit
      Error    : Boolean;      --  1 bit
      Mode     : Mode_Type;    --  2 bits
      Speed    : Speed_Range;  --  4 bits
   end record;

   for Status_Register use record
      Power_On at 0 range 0 .. 0;
      Error    at 0 range 1 .. 1;
      Mode     at 0 range 2 .. 3;
      Speed    at 0 range 4 .. 7;
   end record;
   for Status_Register'Size use 8;  --  Enforce total size of 1 byte

   Status : constant Status_Register :=
     (Power_On => True, Error => False, Mode => Fast, Speed => 5);

   --  Fixed Point Types -----------------------------------------------
   --  Ordinary fixed-point: sensor reading, 0.05 V resolution.
   type Sensor_Voltage is delta 0.05 range 0.0 .. 5.0;

   --  Decimal fixed-point: money, exact to the cent.
   type Dollars is delta 0.01 digits 8;

   procedure Show_Hardware_Modeling is
      Reading : constant Sensor_Voltage := 3.30;
      Price   : constant Dollars        := 19.99;
   begin
      Ada.Text_IO.Put_Line
        ("Status_Register'Size = " & Integer'Image (Status_Register'Size));
      Ada.Text_IO.Put_Line
        ("Status.Mode = " & Mode_Type'Image (Status.Mode)
         & ", Status.Speed = " & Speed_Range'Image (Status.Speed));
      Ada.Text_IO.Put_Line
        ("Sensor_Voltage reading = " & Sensor_Voltage'Image (Reading));
      Ada.Text_IO.Put_Line ("Dollars price = " & Dollars'Image (Price));
   end Show_Hardware_Modeling;

   ------------------------------------------------------------------
   --  03. Concurrency
   ------------------------------------------------------------------

   --  Simple/untyped task: starts automatically. -------------------
   task Hello_Task;

   task body Hello_Task is
   begin
      Ada.Text_IO.Put_Line ("Hello World! from Hello_Task");
   end Hello_Task;

   --  Rendezvous: entries let tasks exchange information. ----------
   task Counter is
      entry Increment;
      entry Get (Result : out Integer);
   end Counter;

   task body Counter is
      Value : Integer := 0;
   begin
      loop
         select
            accept Increment do
               Value := Value + 1;
            end Increment;
         or
            accept Get (Result : out Integer) do
               Result := Value;
            end Get;
         or
            terminate;
         end select;
      end loop;
   end Counter;

   --  Protected Object with Ceiling Priority. -----------------------
   --  Protected operations never block, so a higher-priority task
   --  is never stuck waiting behind a lower-priority one holding
   --  the lock (avoids unbounded priority inversion).
   protected Shared_Data is
      pragma Priority (10);  --  Ceiling priority for this resource
      procedure Update (Val : Integer);
      function Read return Integer;
   private
      Data : Integer := 0;
   end Shared_Data;

   protected body Shared_Data is
      procedure Update (Val : Integer) is
      begin
         Data := Val;
      end Update;

      function Read return Integer is
      begin
         return Data;
      end Read;
   end Shared_Data;

   procedure Show_Concurrency is
      Total : Integer;
   begin
      --  Rendezvous: call the Counter task's entries.
      Counter.Increment;
      Counter.Increment;
      Counter.Increment;
      Counter.Get (Total);
      Ada.Text_IO.Put_Line ("Counter.Get -> " & Integer'Image (Total));

      --  Protected object: no rendezvous needed, just call in/out.
      Shared_Data.Update (42);
      Ada.Text_IO.Put_Line
        ("Shared_Data.Read -> " & Integer'Image (Shared_Data.Read));
   end Show_Concurrency;

   ------------------------------------------------------------------
   --  04. Subprograms
   ------------------------------------------------------------------

   --  A function must return a value and can be used in expressions.
   function Is_Even (N : Integer) return Boolean is
   begin
      return N mod 2 = 0;
   end Is_Even;

   --  Nested subprogram: Show_Parity is only visible inside Task_B,
   --  and it calls the nested function Is_Even.
   procedure Show_Parity (N : Integer) is
   begin
      if Is_Even (N) then
         Ada.Text_IO.Put_Line (Integer'Image (N) & " is even");
      else
         Ada.Text_IO.Put_Line (Integer'Image (N) & " is odd");
      end if;
   end Show_Parity;

   --  Parameter modes ------------------------------------------------
   --  "in"     : input only / read only (the default mode).
   procedure Show_Number (Number : in Integer) is
   begin
      Ada.Text_IO.Put_Line ("Show_Number(in) -> " & Integer'Image (Number));
   end Show_Number;

   --  "out"    : output only, the caller's variable is written by us.
   procedure Get_Number (Number : out Integer) is
   begin
      Number := 20;
   end Get_Number;

   --  "in out" : both read and written.
   procedure Add_Five (Number : in out Integer) is
   begin
      Number := Number + 5;
   end Add_Five;

   procedure Show_Subprograms is
      N : Integer;
   begin
      Show_Parity (4);
      Show_Parity (7);

      Show_Number (3);

      Get_Number (N);
      Ada.Text_IO.Put_Line ("Get_Number(out) -> " & Integer'Image (N));

      Add_Five (N);
      Ada.Text_IO.Put_Line ("Add_Five(in out) -> " & Integer'Image (N));
   end Show_Subprograms;

begin
   Ada.Text_IO.Put_Line ("== 01. Exceptions ==");
   Show_Exceptions;

   Ada.Text_IO.Put_Line ("== 02. Low-Level Hardware Modeling ==");
   Show_Hardware_Modeling;

   Ada.Text_IO.Put_Line ("== 03. Concurrency ==");
   Show_Concurrency;

   Ada.Text_IO.Put_Line ("== 04. Subprograms ==");
   Show_Subprograms;

exception
   when E : others =>
      Ada.Text_IO.Put_Line
        ("Unexpected error: " & Ada.Exceptions.Exception_Message (E));
end Task_B;
