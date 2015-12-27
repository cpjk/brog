import React from "react"
import Comment from "./Comment"

export default class CommentList extends React.Component {
  render() {
    // If the AJAX call for the comments hasn't returned yet,
    // pass an empty array
    let commentNodes = []
    if (this.props.data != undefined){
      commentNodes = this.props.data.map(function(comment){
        return (
          <Comment user={comment.user} key={comment.id}>
            {comment.text}
          </Comment>
        );
      });
    }
    return (
      <div className="commentList">
        {commentNodes}
      </div>
    )
  }
};
