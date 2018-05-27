import * as React from "react";

interface Props {
  text: number;
}
interface State {
  isEnabled: boolean;
}

class HelloWorld extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { isEnabled: false };

    setTimeout(() => {
      this.setState({ isEnabled: true });
    }, 5000);
  }

  handleClick(e) {
    alert("click button");
  }

  render() {
    return (
      <div>
        <h1>Hello React!</h1>
        <p>text is {this.props.text || "none"}</p>
        <p>state is {this.state.isEnabled ? "enabled" : "disabled"}</p>
        <button onClick={this.handleClick}>Button!!</button>
      </div>
    );
  }
}

export default HelloWorld
