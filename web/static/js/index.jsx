import React from 'react';
import ReactDOM from 'react-dom';
import CommentBox from './components/CommentBox.jsx'


main();

function main() {
  ReactDOM.render(
    <CommentBox url={"/api/comments"} pollInterval={2000}/>,
    document.getElementById('comment-content')
  );
};
