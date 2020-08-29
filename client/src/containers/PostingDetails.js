import React from 'react'
import '../Posting.css'

const PostingDetails = (props) => {
  const {posting, setActivePosting, handleModifyPosting} = props

  const handleClick = action => {
    fetch("http://localhost:3000/posting/" + posting.id,{
      method: "PATCH",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({category: action})
    })
      .then(resp => resp.json())
      .then(json => {
        setActivePosting(null)
        handleModifyPosting(json)
      })
  }

  const stopwords = ["clearance", "Clearance", "US Citizen", "PHP", "Senior", "TS/SCI"]

  const checkForStopwords = (text) =>{
    if (text){
      stopwords.forEach(word => {
        text = text.split(word).join(`<em class = red>${word}</em>`)
      })

      return <div dangerouslySetInnerHTML={{ __html: text}} />
    }
    else {
      return null
    }
  }

  if (!posting){
    return null
  }
  else {
    return (
        <div className="details" >
          <div className = "buttonsContainer">
            <button className = "apply" onClick = {() => handleClick("applied")}> Applied </button>
            <button className = "unrelevant" onClick = {() => handleClick("unrelevant")}> Not Relevant </button>
            <button className = "expired" onClick = {() => handleClick("expired")}> Expired </button>
          </div>
          <a href = {posting.link} target="_blank" rel="noopener noreferrer"  >{posting.title}</a>
          <p>{posting.keywords}</p>
          <div>
            {posting ? checkForStopwords(posting.description) : null}
          </div>
          {/* <iframe src = {posting.link}>

          </iframe> */}
        </div>
    )
  }
}

export default PostingDetails