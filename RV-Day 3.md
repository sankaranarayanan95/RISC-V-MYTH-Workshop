# Digital Logic with TL-Verilog and Makerchip
## 1) Combinational logic in TL-Verilog using Makerchip
### L1. Introduction to Logic Gates
1.**Logic Gates** are *fundamental building blocks* for digital circuits which take one or more inputs (1s or 0s) and give an output based on the logic.

  ![Screenshot 2025-04-25 170303](https://github.com/user-attachments/assets/3f92dc6f-33c9-4a0f-9b03-8a252eae09dd)

2.**Combinational circuits** are complex digital circuits that rely on fundamental building blocks, such as logic gates (AND, OR, NOT, XOR, etc.). They determine their outputs solely based on current inputs, without utilizing any memory or feedback mechanisms.

  ![Screenshot 2025-04-25 172211](https://github.com/user-attachments/assets/f4268b47-d086-498d-9542-12d643ac77d3)   ![Screenshot 2025-04-25 172855](https://github.com/user-attachments/assets/b28965fa-1fe0-44cf-9161-e1fc141d7ce4)

*Example*: Full Adder (adds 3 bits together) :
- Inputs: A, B, Cin (carry-in)  
- Outputs: S (sum), Cout (carry-out)

3.**Boolean Operators** are logical connectors used to evaluate conditions in programming and digital logic.

   ![Screenshot 2025-04-25 173724](https://github.com/user-attachments/assets/8b003fb5-b129-4331-b1c3-59c4c27970ca)

------

### L2. Basic Mux Implementation And Introduction To Makerchip
- A **MUX (Multiplexer)** selects one of multiple inputs and forwards it to a single output based on control signals. It's like a data switch!
- Its Verilog syntex is : assign f = s ? X1 : X2;

**Navigation through Makerchip** 
   ![Screenshot 2025-04-25 182522](https://github.com/user-attachments/assets/d9300c55-1184-4945-851d-d263a4ed85bc)

### L3.1  Labs for Cominational Logic
**Example: Pythagores Theorem** 
   ![Screenshot 2025-04-25 183421](https://github.com/user-attachments/assets/14a05137-fb1f-4f72-8c20-ed6936f7135b)


#### Inverter
   ![Screenshot 2025-04-25 190221](https://github.com/user-attachments/assets/677a4b24-733d-4fce-af75-3c5ebdcb37f5)


#### Other logic : Boolean operators ( && , || , ^ )
   ![Screenshot 2025-04-25 192740](https://github.com/user-attachments/assets/c5d5b34b-f0af-4e3a-afdf-2d5ffaf2a299)


### L3.2  Vectors
**Vectors of 5 bits**
   ![Screenshot 2025-04-25 193430](https://github.com/user-attachments/assets/08a8dca7-9a5b-41e1-b6a7-f126eb7543ae)

### L3.3  Mux
**1.[ 2:0 ] Mux**
   ![Screenshot 2025-04-25 193910](https://github.com/user-attachments/assets/3724e8b0-b5e4-4ff3-baf4-6740a54ea19f)

 
**2. [ 7:0 ] Mux**
   ![Screenshot 2025-04-25 194116](https://github.com/user-attachments/assets/f50a333a-bdd6-4de4-8928-f7d56a8daf40)

### L3.4  Combinational Calculator
   ![Screenshot 2025-04-25 195741](https://github.com/user-attachments/assets/1595a276-9c26-45ae-892b-d627b0d84e03)

-----

## 2) Sequential Logic 
### L1.  Introduction to Sequential Logic and Counter Lab 
Sequential logic is sequenced by a clock signal.
Example: D-flip-flop transition next state to current state on a rising clock edge
The circuit is constructed to enter a known state in response to a reset signal.

#### Fibonacci Series LAB
-Next value is sum of previous two: 1,1,2,3,5,8,13... { $num[31:0] = $reset ? 1 : >>1$num + >>2$num; }
   ![Screenshot 2025-04-25 201816](https://github.com/user-attachments/assets/b460bcd1-4bc1-4f84-b962-9c7e092083f3)

#### Counter LAB
   ![Screenshot 2025-04-25 203201](https://github.com/user-attachments/assets/635ec6ff-ae17-44ef-b151-11518b9875f3)

### L2.  Sequential Calculator Lab
Values in Verilog
eg: 16'hFO where 16 - 16-bits; h - hexadecimal; FO - value 
   ![Screenshot 2025-04-25 212255](https://github.com/user-attachments/assets/34e5ae43-4bef-43de-b794-83e59d33b8a8)
   ![Screenshot 2025-04-27 145412](https://github.com/user-attachments/assets/e64896ec-025e-41e5-8478-22960a1e15c5)

-----

## 3)  Pipelined logic
### L1. Pipelined Logic And Re-Timing
- **Pipeline logic** refers to the structured approach of breaking down a process into sequential stages, where each stage processes data and passes it to the       next. This technique is widely used to improve efficiency and throughput.
- In the comparison between **SystemVerilog and TL-Verilog**, the code reduction property of TL-Verilog offers a significant advantage over SystemVerilog. This reduction minimizes bugs and accelerates the design process, making development more efficient.

### L2. Pipeline Logic Advantages And Demo In Platform
- Pipeline logic enhances efficiency by breaking tasks into stages, enabling parallel execution.
- It speeds up processing, optimizes resource use, reduces latency, improves scalability, and supports automation in workflows.
   ![Screenshot 2025-04-27 124530](https://github.com/user-attachments/assets/008f894c-974b-4b00-bf2f-3d250210bb9b) 

### L3. Lab On Error Conditions Within Computation Pipeline
- **Identifier Type Determination** – The type of an identifier is defined by its symbol prefix and case/delimitation style.
- **Example Breakdown** – `$pipe_signal`  
   - **Symbol Prefix:** `$`  
   - **Delimitation Style:** `_`  
   - **Tokens:** `pipe`, `signal`
- **Delimitation Styles Based on First Token:**  
   - `$lower_case` → pipe signal  
   - `$CamelCase` → state signal  
   - `$UPPER_CASE` → keyword signal  
- **Numbers Affect Tokens:**  
   - `$base64_value` is valid  
   - `$bad_name_5` is invalid
- **Numeric Identifiers:**  
   - `>>1` represents "ahead by 1".
   ![Screenshot 2025-04-25 225504](https://github.com/user-attachments/assets/be75aae1-7ecb-4fb9-9a8c-fa91941e9e93)

### L4. Lab On 2-Cycle Calculator

  ![Screenshot 2025-04-25 230058](https://github.com/user-attachments/assets/23c5ac98-b9bd-4919-ac31-613a3300c0e4)

----

## 4)  Validity
### L1. Introduction To Validity And Its Advantages
### L2. Lab On Validity And Valid When Condition

  ![Screenshot 2025-04-30 195005](https://github.com/user-attachments/assets/e6ea3585-cf81-46ca-8374-5ac6ce314db9)


### L3. Lab To Compute Total Distance

  ![Screenshot 2025-04-25 232757](https://github.com/user-attachments/assets/06ddb65a-4f68-473b-8b7e-0188628df2c4)


### L4. Lab on 2-cycle Calculator with Validity

  ![Screenshot 2025-04-25 231907](https://github.com/user-attachments/assets/79b34ad7-70ed-4cfc-8c9b-1df48cf0efa3)

### L5. Calulator Single Value Memory Lab

  ![Screenshot 2025-04-25 232410](https://github.com/user-attachments/assets/3a9b6863-ab94-428e-99aa-735a7b2f43f6)













