import JQuery from "jquery"
import React from "react"
import CommentForm from "./CommentForm"
import CommentList from "./CommentList"

export default class CommentBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {data: []};
  }

  loadCommentsFromServer() {
    JQuery.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: data => {
        this.setState({data: data.comments});
      },
      error: (xhr, status, err) => {
        console.error(this.props.url, status, err.toString());
      }
    });
  }

  componentDidMount() {
    this.loadCommentsFromServer();
    setInterval(this.loadCommentsFromServer.bind(this),
                this.props.pollInterval);
  }

  handleCommentSubmit(comment) {
    JQuery.ajax({
      url: this.props.url,
      dataType: "json",
      type: "POST",
      data: {comment: comment},
      success: data => {
        this.setState({data: data.comments});
        console.log("post successful", data)
      },
      error: (xhr, status, err) => {
        console.error(this.props.url, status, err.toString());
      }
    });
  }
  render() {
    return (
      <div className="CommentBox">
        <h1>Comments</h1>
        <CommentForm onCommentSubmit={this.handleCommentSubmit.bind(this)}/>
        <CommentList data={this.state.data}/>
      </div>
    );
  }
};

