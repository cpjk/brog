import React from "react"
import marked from "marked"

export default class Comment extends React.Component {
  render() {
    return (
      <div className="comment">
        <h2 className="commentAuthor">
          {this.props.user.first_name} {this.props.user.last_name}
        </h2>
        {this.props.children}
      </div>
    )
  }
}
