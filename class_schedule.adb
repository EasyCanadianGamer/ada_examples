with Ada.Text_IO;
use Ada.Text_IO;

procedure Class_Schedule is

   -- A class request
   type Class_Name is (CSC470, CSC435, CSC415);

   -- Registrar task
   task Registrar is
      entry Schedule (Class : Class_Name);
   end Registrar;

   -- Student tasks
   task Student_A;
   task Student_B;

   -- Registrar receives requests
   task body Registrar is
   begin
      for I in 1 .. 5 loop

         -- TODO:
         -- Use task selection to receive a class request.

         Put_Line ("Registrar scheduled a class.");

      end loop;
   end Registrar;

   -- Student A
   task body Student_A is
   begin
      -- TODO:
      -- Send two class requests to the Registrar.

      delay 1.0;

      -- TODO:
      -- Send another class request.

   end Student_A;

   -- Student B
   task body Student_B is
   begin
      -- TODO:
      -- Send two class requests to the Registrar.

      null;

   end Student_B;

begin
   Put_Line ("Class registration is open!");
end Class_Schedule;