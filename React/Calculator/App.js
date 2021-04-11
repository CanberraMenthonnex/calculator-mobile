import React, { Component } from 'react';
import { View, Text, AppRegistry } from 'react-native';
import Style from './src/Style';
import InputButton from './src/InputButton';

const inputButtons = [
  [1, 2, 3, '/'],
  [4, 5, 6, '*'],
  [7, 8, 9, '-'],
  [0, '.', 'ce', '+'],
  ['cos','sin','c','=']
];


class ReactCalculator extends Component {
    
    constructor(props) {
        super(props);
        
        this.state = {
          previousInputValue: 0,
          inputValue: 0,
          selectedSymbol: null,

          decimal: null,
          
          inc: 1,
      }
    }

  _renderInputButtons() {
    let views = [];

    for (var r = 0; r < inputButtons.length; r ++) {
        let row = inputButtons[r];

        let inputRow = [];
        for (var i = 0; i < row.length; i ++) {
            let input = row[i];

            inputRow.push(
              <InputButton
                  value={input}
                  onPress={this._onInputButtonPressed.bind(this, input)}
                  key={r + "-" + i}/>
          );
        }
        views.push(<View style={Style.inputRow} key={"row-" + r}>{inputRow}</View>)
    }

      return views;
  }

  _onInputButtonPressed(input) {
    switch (typeof input) {
        case 'number':
            return this._handleNumberInput(input)
        case 'string':
            return this._handleStringInput(input)
    }
}

  _handleNumberInput(num) {
    let inputValue = null,
    inc = this.state.inc;

    if (this.state.decimal != '.') {
      inputValue = (this.state.inputValue * 10) + num;
    }else{
      inputValue = this.state.inputValue + this._handleNumberInputToDecimal(num, inc);
      inc++;
    }

    this.setState({
        inputValue: inputValue,
        inc: inc
    })
  }


  _handleNumberInputToDecimal(num, inc){
    while(inc > 0){
      num = num /10;
      inc--;
    }
    return num;
  }

  _handleStringInput(str) {
    switch (str) {
        case '/':
        case '*':
        case '+':
        case '-':
            this.setState({
                selectedSymbol: str,
                previousInputValue: this.state.inputValue,
                inputValue: 0,
                decimal: null,
                compteur: 1,
            });
        break;
        case '=':
            let symbol = this.state.selectedSymbol,
                inputValue = this.state.inputValue,
                previousInputValue = this.state.previousInputValue;

            if (!symbol) {
                return;
            }

            this.setState({
                previousInputValue: 0,
                inputValue: eval(previousInputValue + symbol + inputValue),
                selectedSymbol: null,
                decimal:null,
                compteur: 1
            });
            console.log()
        break;
        case 'ce':
            this.setState({
              inputValue: 0,
              
              compteur: 1,
              decimal:null,
            });
        break;
        case 'c':
          let TruncateValue = Math.trunc(this.state.inputValue /10);
          this.setState({
            inputValue: TruncateValue,
            strSymbol: null,
            compteur: 1
          });
        break;
        case '.':
          this.setState({
            decimal: '.',
            
            compteur: 1
          });
        break;
    }
  }


  render() {
      return (
          <View style={Style.rootContainer}>
              <View style={Style.displayContainer}>
                  <Text style={Style.displayText}>{this.state.inputValue}</Text>
              </View>
              <View style={Style.inputContainer}>
                  {this._renderInputButtons()}
              </View>
          </View>
      )
  }
}
 
export default ReactCalculator
 
