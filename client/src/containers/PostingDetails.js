import React from 'react'

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

  const stopwords = ["clearance", "Clearance", "US Citizen", "PHP", "Senior"]

  const checkForStopwords = (text) =>{
    if (text){
      stopwords.forEach(word => {
        text = text.split(word).join(`<p class = red>${word}<p>`)
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
          <p>
            {posting ? checkForStopwords(posting.description) : null}
          </p>
        </div>
    )
  }
}

export default PostingDetails