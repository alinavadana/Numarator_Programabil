# Numarator Programabil

Acest proiect implementeaza si verifica un **numarator programabil** folosind Verilog si SystemVerilog. Proiectul include atat partea de design hardware, cat si un mediu de verificare construit pe baza de tranzactii, generator, driver, monitor, scoreboard si coverage.

Scopul proiectului este testarea functionarii unui numarator configurabil prin registre, cu suport pentru operatii de scriere/citire, semnal de validare, reset si detectie de overflow.

## Functionalitati

- Numarator programabil pe 8 biti
- Configurare prin registre interne
- Operatii de scriere si citire
- Semnal de validare pentru tranzactii
- Reset activ
- Semnal de overflow
- Testbench SystemVerilog
- Generator de tranzactii random
- Driver pentru aplicarea stimulilor
- Monitoare pentru intrari si iesiri
- Coverage functional pentru semnale si tranzactii
- Scoreboard pentru verificarea rezultatelor

## Arhitectura proiectului

Mediul de verificare este format din urmatoarele componente:

- **DUT** - modulul numaratorului programabil
- **interface_in.sv** - interfata pentru semnalele de intrare
- **interface_out.sv** - interfata pentru semnalele de iesire
- **transaction_in.sv** - descrierea tranzactiilor de intrare
- **transaction_out.sv** - descrierea tranzactiilor de iesire
- **generator_in.sv** - generatorul de tranzactii
- **driver_in.v** - driverul care aplica tranzactiile catre DUT
- **monitor_in.v** - monitor pentru semnalele de intrare
- **monitor_out.sv** - monitor pentru semnalele de iesire
- **scoreboard.sv** - compararea rezultatelor asteptate cu cele obtinute
- **coverage_in.sv** - coverage pentru intrari
- **coverage_out.sv** - coverage pentru iesiri
- **enviroment.sv** - conectarea componentelor mediului de test
- **testbench.sv** - modulul principal de simulare

## Semnale principale

| Semnal | Descriere |
|---|---|
| `clk_i` | Semnal de ceas |
| `rst_ni` | Reset activ pe 0 |
| `valid_i` | Valideaza tranzactia curenta |
| `rd_wr_i` | Selectie operatie: citire/scriere |
| `addr_i` | Adresa registrului accesat |
| `d_in` | Date de intrare |
| `d_out` | Date citite din registru |
| `count_o` | Valoarea curenta a numaratorului |
| `ovf_o` | Semnal de overflow |

## Testare

Proiectul include mai multe tipuri de teste:

- test simplu de scriere si citire
- test cu tranzactii random
- test pentru valori limita
- verificarea semnalului de overflow
- verificarea semnalelor prin assertions
- colectarea coverage-ului functional

Testele sunt rulate din `testbench.sv`, unde se instantiaza interfetele, mediul de test si modulul DUT.

## Coverage

Coverage-ul este folosit pentru a verifica daca au fost acoperite scenarii importante, precum:

- operatii de citire si scriere
- accesarea adreselor disponibile
- valori mici, medii si mari pentru date
- valori limita, precum `0` si `255`
- aparitia overflow-ului
- intarzieri diferite intre tranzactii

## Rulare simulare

Proiectul poate fi simulat intr-un simulator compatibil SystemVerilog, precum:

- ModelSim / QuestaSim
- Xcelium
- VCS
- EDA Playground

Pentru rulare, se compileaza fisierele Verilog/SystemVerilog si se porneste simularea din `testbench.sv`.

## Tehnologii utilizate

- Verilog
- SystemVerilog
- Testbench bazat pe clase
- Interfaces si clocking blocks
- Assertions
- Functional coverage
- Scoreboard-based verification

## Posibile imbunatatiri

- Extinderea scoreboard-ului pentru mai multe scenarii
- Adaugarea mai multor teste directionate
- Cresterea coverage-ului functional
- Organizarea proiectului pe foldere
- Adaugarea unui script automat de simulare
- Documentarea registrelor interne ale numaratorului


