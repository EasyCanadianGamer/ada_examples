with Ada.Text_IO;

package body Simple_Task_Pkg is

   task body Simple_Task is
   begin
      Ada.Text_IO.Put_Line ("Hello from a Ravenscar-compliant task!");
   end Simple_Task;

end Simple_Task_Pkg;
