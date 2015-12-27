import React from "react"

export default class CommentForm extends React.Component {
  render() {
    return (
      <form className="commentForm" action="/api/comments" method="post">
        <input type="text" placeholder="Say something..." name="comment[text]" />
        <input type="submit" value="Post" />
      </form>
    );
  }
};
