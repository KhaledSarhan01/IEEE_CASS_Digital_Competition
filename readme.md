# IEEE CASS Digital Competition 
## Brief Notes:
* System works with Fixed Signed 8 bit Representation `Q0.7`.
* Weights are stored in Block ROMs for DNN and Distrubited ROMs for CNN.
* Feature Map/Vectors are Stored in Distrubited RAM for DNN and Block RAM for CNN. 
## TODO:
- [x] Initial Design For the system.
- [ ] Write a Documentation for the System
- [ ] Design and Test CNN.
    - [ ] Design and Test PE. 
    - [ ] Design and Test PE Matrix.
    - [ ] Design and Test Maxpool.
    - [ ] Design and Test CNN Control.
- [ ] Design and Test DNN.
    - [ ] Design and Test MAC.
    - [ ] Design and Test Relu.
    - [ ] Design and Test DNN Control.
- [ ] Design and Test RAM/ROM.
    - [ ] Design and Test RAM for Variables.
    - [ ] Design and Test ROM for Weights.
    - [x] Memory Mapping for each RAM.
    - [ ] Memory Mapping for each ROM.
- [ ] Design and Test Communication Protocol.
    - [ ] Design and Test UART Rx.
    - [ ] Design and Test Uart2Memory Control.
- [ ] Design and Test Output Layer.
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