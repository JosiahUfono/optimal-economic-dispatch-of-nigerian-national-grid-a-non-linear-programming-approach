$title Economic Dispatch with Transmission Losses

$onText
Written by
Ufono, Josiah Unimke
Email: josiahufono@gmail.com
$offText

Sets
    g Generators / G1*G26 /;

Parameters
    a(g) Quadratic cost coefficient
    b(g) Linear cost coefficient
    c(g) Constant cost coefficient
    Pmin(g) Minimum power generation
    Pmax(g) Maximum power generation;

Table GeneratorData(g,*)
     a         b          c         Pmin        Pmax
G1  0.0095   19.3      1.15        241         578.4
G2  0.0091   18.6      1.21        279          760
G3  0.0091   19.8      1.36        421          600
G4  0.0721   32.6      5.47        202         461
G5  0.0109   28.4      3.92        118         1100
G6  0.0591   22.6      8.10        33          223
G7  0.0757   32.6      6.47        49          110
G8  0.0743   33.4      9.85        22          434
G9  0.0201   31.3      1.25        14          450
G10 0.0514   31.2      4.70        29          480
G11 0.0294   31.3      2.80        10          293
G12 0.0834   28.9      2.03        24          453
G13 0.0105   22.7      5.60        30          373
G14 0.0200   33.2      1.00        34          87
G15 0.0223   31.4      1.00        94          272
G16 0.0287   31.3      1.70        31          422
G17 0.0179   30.3      2.64        20          225
G18 0.020    29.4      1.00        91          120
G19 0.0326   28.6      4.53        100         475
G20 0.0115   25.9      8.00        45          656
G21 0.0133   27.4      4.30        51          242
G22 0.0133   31.4      1.30        3           65
G23 0.0189   31.2      4.60        10          101
G24 0.0315   32.1      1.00        4           31
G25 0.0215   31.8      6.00        20          160
G26 0.0203   28.1      1.75        4           562;

* Assign data from table to parameters
a(g) = GeneratorData(g,"a");
b(g) = GeneratorData(g,"b");
c(g) = GeneratorData(g,"c");
Pmin(g) = GeneratorData(g,"Pmin");
Pmax(g) = GeneratorData(g,"Pmax");

Scalar
    Pd Demand
    LossFactor Transmission loss factor / 0.07 /;

Pd = 8100;

* Example demand

Variables
    Pg(g) Power generation
    TotalCost Total generation cost;

Equations
    CostFunction Total cost calculation
    DemandBalance Power balance equation
    MinPowerLimits(g) Minimum power generation limits
    MaxPowerLimits(g) Maximum power generation limits;
   

MinPowerLimits(g).. Pg(g) =g= Pmin(g);
MaxPowerLimits(g).. Pg(g) =l= Pmax(g);

CostFunction.. TotalCost =e= sum(g, a(g)*Pg(g)*Pg(g) + b(g)*Pg(g) + c(g));

DemandBalance.. (1 - LossFactor)*sum(g, Pg(g)) =e= Pd;



Model EconomicDispatch / all /;

Solve EconomicDispatch using NLP minimizing TotalCost;

Display Pg.l, TotalCost.l;