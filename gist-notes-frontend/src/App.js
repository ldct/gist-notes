import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      message: '',
      results: [],
    };
  }
  handleChange(event) {
    this.setState({message: event.target.value});
    fetch('http://localhost:4000/q/' + event.target.value).then(function(response) {
      return response.json();
    }).then((j) => {
      this.setState({
        results: j,
      });
    });
  }
  render() {
    var message = this.state.message;
    return <div style={{margin: 10}}>
      <input type="text" value={message} onChange={this.handleChange.bind(this)} />
      {this.state.results.map((res) => <a href={"https://gist.github.com/zodiac/" + res.id}>
        <div style={{border: '1px solid pink'}}>
        <span>{res.trunc_content}</span>
      </div>
      </a>)}
    </div>
  }
}

export default App;
