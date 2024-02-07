import 'utils/weight.dart';

class SetWeight {
  String id;
  Weight weight;

  SetWeight({this.id, lb, kg}){
    this.weight = new Weight(lb: lb, kg: kg);
  }
  
}