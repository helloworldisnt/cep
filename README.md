Open Terminal in designs directory 

Run the following commands; 

```
mkdir cep
cd cep
git init
git pull https://github.com/helloworldisnt/cep.git
```

To run all scripts

```
yosys -C
source synthesis.tcl
```
```
//Now openroad
openroad -gui
source recent.tcl //In openroad gui terminal
```
