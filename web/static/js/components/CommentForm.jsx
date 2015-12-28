import React from "react"

export default class CommentForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: ""};
  }

  handleTextChange(e) {
    this.setState({text: e.target.value});
  }

  handleSubmit(e) {
    e.preventDefault();
    let text = this.state.text.trim();
    if (!text) {
      return;
    }
    this.props.onCommentSubmit({text: text});
    this.setState({text: ''});
  }

  render() {
    return (
      <form className="commentForm" onSubmit={this.handleSubmit.bind(this)}>
        <input
          type="text"
          placeholder="Say something..."
          name="comment[text]"
          value={this.state.text}
          onChange={this.handleTextChange.bind(this)}/>
        <input type="submit" value="Post" />
      </form>
    );
  }
};
