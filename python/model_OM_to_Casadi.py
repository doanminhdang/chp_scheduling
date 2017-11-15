# Collect the equations from the initiated model
OM_model='KWKK_model_V49_instantiate.txt'
with open(OM_model,'rt') as file:
  listtext=file.readlines()

OM_equation_lines='KWKK_V49_equations_from_initiated_model.csv'
with open(OM_equation_lines,'rt') as linefile:
  lines=linefile.readlines()

intlines=[int(row) for row in lines]

equation_file = 'equations_KWKK_V49.txt'
with open(equation_file,'wt') as file:
  [file.write(listtext[linenum-1].lstrip(' ')) for linenum in intlines]

# Remove trailing '_' in the names from Open Modelica variables
OM_var_name='list_OM_var_name.csv'
with open(OM_var_name,'rt') as file:
  vars_OM=file.read().splitlines()

vars_OM_new = [varname.rstrip('_') for varname in vars_OM]
new_OM_file = 'list_OM_var_name_notrailing.csv'
with open(new_OM_file,'wt') as file:
  file.write("\n".join(vars_OM_new))

# Read list of Casadi variable names
Casadi_var_name='list_Casadi_var_name.csv'
with open(Casadi_var_name,'rt') as file:
  vars_Casadi=file.read().splitlines()

# Replace Open Modelica variable names with Casadi variable names
with open(equation_file,'rt') as file:
  equation_text=file.read()

for k in range(len(vars_Casadi)):
  equation_text = equation_text.replace(vars_OM_new[k], vars_Casadi[k])

# Remove the class name like "CHP."
import re
noparent_text=equation_text
#pattern=r"(\b[a-zA-Z_]+)\."  # classname without a digit
#noparent_text=re.sub(pattern, '', noparent_text)

# Pattern meaning: at least one letter in the group a-z|A-Z|_, and count from a beginning of the word to the dot .
pattern=r"(?=[a-zA-Z_]+?)\b[a-zA-Z1-9_]+\."
noparent_text=re.sub(pattern, '', noparent_text)

# Change the syntax for exponential: in OM is ^, in Python is **
pattern=r"\^"
noparent_text=re.sub(pattern, '**', noparent_text)

# Remove other unneccessary symbols
pattern=r"(_+)\b"
noparent_text=re.sub(pattern, '', noparent_text)

pattern=r"\".+\""
noparent_text=re.sub(pattern, '', noparent_text)

pattern=r";"
noparent_text=re.sub(pattern, '', noparent_text)

equation_Casadi_name = 'equations_KWKK_V49_Casadi_name.txt'
with open(equation_Casadi_name,'wt') as file:
   file.write(noparent_text)
