--  06. The Ravenscar Profile
--  ---------------------------------------------------------------
--  pragma Profile (Ravenscar) is a *configuration* pragma: it must
--  come before the context clauses, and it applies to the whole
--  partition (executable). It restricts tasking to a predictable,
--  analyzable subset -- e.g. tasks only at library level, one
--  entry per task, no "select", no "abort" -- which is why this
--  lives in its own tiny program instead of being merged into
--  Task_B (whose Counter task is declared inside a procedure and
--  uses "select ... or terminate" with two entries, both
--  disallowed under Ravenscar).
pragma Profile (Ravenscar);

with Simple_Task_Pkg;
pragma Unreferenced (Simple_Task_Pkg);

procedure Ravenscar_Demo is
begin
   null;  --  Simple_Task starts on its own; we just wait for it
end Ravenscar_Demo;
