--  Ravenscar requires "No_Task_Hierarchy": tasks may only be
--  declared at library level, so this task lives in a package
--  instead of inside a procedure.
package Simple_Task_Pkg is

   task Simple_Task is
      pragma Priority (10);
   end Simple_Task;

end Simple_Task_Pkg;
