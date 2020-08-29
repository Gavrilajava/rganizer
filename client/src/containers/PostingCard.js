import React from 'react'

const PostingCard = (props) => {
  const {posting, setActivePosting, active} = props
  let style
  active? style = {border: "2px solid red"} : style = {}
  return (
      <div  className="card" style = {style} onClick = {() => setActivePosting(posting)}>
        <div className="content">
          <div className="header">
            {posting.title}
          </div>
          <div className={posting.applied ? "meta red" : "meta"}>
            {posting.company}
          </div>
          <div className="description">
            {`${posting.city}, ${posting.state} ${posting.salary ? posting.salary : "" }`}
          </div>
        </div>
      </div>
  )
}

export default PostingCard