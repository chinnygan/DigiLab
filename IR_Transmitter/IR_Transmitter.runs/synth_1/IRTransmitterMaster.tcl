# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.cache/wt [current_project]
set_property parent.project_path /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.srcs/sources_1/new/NewCounter.v
  /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.srcs/sources_1/imports/Snake/Seg7Decoder.v
  /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.srcs/sources_1/new/IRTransmitterSM.v
  /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.srcs/sources_1/new/IRTransmitterMaster.v
}
read_xdc /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.srcs/constrs_1/new/IRTransmitterMaster_constraints.xdc
set_property used_in_implementation false [get_files /afs/inf.ed.ac.uk/user/s12/s1231893/Digilab/IR_Transmitter/IR_Transmitter.srcs/constrs_1/new/IRTransmitterMaster_constraints.xdc]

synth_design -top IRTransmitterMaster -part xc7a35tcpg236-1
write_checkpoint -noxdef IRTransmitterMaster.dcp
catch { report_utilization -file IRTransmitterMaster_utilization_synth.rpt -pb IRTransmitterMaster_utilization_synth.pb }
