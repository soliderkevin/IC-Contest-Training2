// Q.Not passing Register transfering clock,
/* A.In case of clk abusing, we have to insert one "D-FF" in between of terminal clk and beginning clk.
*/

/*Q.When signal not too short, it'll be passed, How to fix the problem?
A.With the help of "synchronizer(Consisted of two flip-flops, with A_clk*1.5 of B_clk clk length in open-loop from the experience,)
; "Closed-loop" wired the signal from synchronizer(two D-FF) back to register.

/*
Q.Solve the multi-bits transfering problem?
A. With"a single control signal called"ben"" to do the control.
*/

/*Warning: The surgeon General has determined that passing "binary-coded and one-hot signals through a brute-force" synchronizer can be hazardous to your circuits.
Q. What's the "brute-force synchronizer"?

L13
/*Q. How CPU access these I/O interface?
  A.Memory mapped I/O(treat other components as memory.)

Q. How do you pass data from one module to another/
A1. Open loop(just sending data), Flow control(feedback sending data), serialized(one time one bit sending.),
More complex methods are outside chips, since the module "area" is retricted and the uncertain is high.

Q. Complex method to transfer data?
A.Serialization, USB, SATA, I2C, I2C
I2C:Mostly used on audio.
I2S:Multi-bits to one-bit p.g:4 bits ->1 bit
Serialization:frame control signal(Tx傳送端)+bus,Ready signal(Rx) to maintain the data and delay it until being recieved.
Common interface signal including 3 parts.: Control,Address,Data,
In "Control": Sequential signal circumstance only needs to send "1 starting data" and non-sequential circumstance "need all datas sent".

Q. Method to deal with interconnection when dealing with different clients?
A.
1. "Sharing bus interfaces", Bus interface + bus arbriter. (before client connecting bus, there's many "bus interface" between it and bus.)
2. "Crossbar switch", sending client 0 -> client 0(can't have other clients sharing) one-time many interface but different clients.
pros:crossbarswitch,fast tranfer for single data.
cons: When client have more, the delay will be longer.
3. Interconnection Network(Noc)
a cell : 2 clients + 1 router
pros: Automatically pathtracking the shortest path. 
cons: Expensive.

Bandwidt scalability NoC> crossbar >bus
Cost : Bus < crossbar < NoC.

SRAM: Composed of column drivers + n-bit wor cells, bitcell array, bitlines for bit n, sense amplifiers, address decoder.
SRAM send: send address, when read-> read signal up. when write-> write signal up + write data up at the same time
address and data signal sent in at the same time.
AHB was the pipeline one that signals not needed to be sent in at the same time.

DRAM:
DRAM send:1.Send bank address
When changing "page" or "bank", it'll require the "EXTRA Cycle" compare to Sram.

Increasing capacity method:
1. Bit Slicing
many registers(slices).
parrallel alot of slicing registers to increase capacity.
2. Banking
1 decoder + many registers(banks).
one time one read/write register while others can register can be closed.
and banking method is used on "interleaving(many datas read/write at the same time)".