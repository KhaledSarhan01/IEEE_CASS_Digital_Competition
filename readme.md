# IEEE CASS Digital Competition 
## Brief Notes:
* We use Posedge Asynchronous Reset.
* For Weights, we will use `Q0.7 signed`.
* For Features, we will use `Q4.4 Unsigned`.
* For Multipler outputs/ Addition Inputs , we will use `Q4.11 signed`.
* Most of image/Features has zero values so to save power we can use sparse multiplication.
* No Features less than zero since we use Relu activation Function so all Feautres has unsigned Fixed point Representation.
* Weights are stored in Block ROMs for DNN and Distrubited ROMs for CNN.
* Feature Map/Vectors are Stored in Distrubited RAM for DNN and Block RAM for CNN. 
## Blocks
### Utils Blocks 
#### RelU Block 
##### Port Mapping 
| Port | Direction | Format |
| :--- | :----: | :---: |
| relu_in| Input |`Q4.11 signed`|
| relu_out| Output |`Q4.4 unsigned`|
##### Features
- ```relu_out = max(0,relu_in)``` as Pure Combinational Logic.
- apply output mapping from `Q4.11 signed` into `Q4.4 unsigned` with Saturating Convergent Rounding. 
#### Multipler 
##### Port Mapping 
| Port | Direction | Format |
| :--- | :----: | :---: |
| weights| Input| `Q0.7 signed`|
| features|Input |`Q4.4 unsigned`|
| out| Output|`Q4.11 signed`|
##### Features
- Desiged to multiply `Q4.4 unsiged` with `Q0.7 signed` as pure combinational Logic.
- Designed with Sparsity,bypassing the multiplier when one of inputs equal zero,which results in better power consumbtion.
## TODO:
- [x] Initial Design For the system.
- [x] Fixed Point Analysis on Weights and Features.
- [x] Parameter Extraction:
    - [x] Weights Extraction.
    - [x] Feature Extraction per random image.
- [ ] Write a Documentation for the System
- [ ] Design and Test CNN.
    - [ ] Design and Test PE. 
    - [ ] Design and Test PE Matrix.
    - [ ] Design and Test Maxpool.
    - [ ] Design and Test CNN Control.
- [x] Design and Test DNN.
    - [x] Design and Test MAC.
    - [x] Design and Test DNN Control.
- Design and Test RAM/ROM.
    - [x] Design and Test RAM for Variables.
    - [x] Design and Test ROM for Weights.
    - [x] Memory Mapping for each RAM.
    - [ ] Memory Mapping for each ROM.
- [ ] Design and Test Communication Protocol.
    - [ ] Design and Test UART Rx.
    - [ ] Design and Test Uart2Memory Control.
- [ ] Design and Test Output Layer.
- [x] Design and Test Utils Blocks.
    - [x] Design and Test Multipler Block.
    - [x] Design and Test Relu Block.
- [ ] Design and Test LeNet5_top.
    - [ ] Design and Test Communication Protocol.
    - [ ] Design and Test Input_Feature.
    - [ ] Design and Test conv1_layer.
    - [ ] Design and Test Feature_Map_1.
    - [ ] Design and Test conv2_layer.
    - [ ] Design and Test Feature_Map_2.
    - [ ] Design and Test dense1_layer.
    - [ ] Design and Test Feature_Vector_1.
    - [ ] Design and Test dense2_layer.
    - [ ] Design and Test Feature_Vector_2.
    - [ ] Design and Test output_dense_layer.
    - [ ] Design and Test Out_layer.