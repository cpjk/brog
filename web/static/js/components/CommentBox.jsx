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
      success: function(data) {
        this.setState({data: data.comments});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  }

  componentDidMount() {
    this.loadCommentsFromServer();
    // setInterval(this.loadCommentsFromServer.bind(this),
    //             this.props.pollInterval);
  }

  render() {
    return (
      <div className="CommentBox">
        <h1>Comments</h1>
        <CommentForm />
        <CommentList data={this.state.data}/>
      </div>
    );
  }
};

