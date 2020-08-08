import React, {useState, useEffect} from 'react'
import PostingCard from './PostingCard'
import PostingDetails from './PostingDetails'

const PostingsContainer = () => {

  const [postings, setPostings] = useState([])
  const [activePosting, setActivePosting] = useState(null)

  useEffect(() => {
    if (postings.length === 0){
      fetch("http://localhost:3000/postings")
        .then(resp => resp.json())
        .then(json => setPostings(json))
    }

  }, [postings])

  const handleModifyPosting = (posting) => {
    setPostings(postings.filter(p => p.id !== posting.id))
  }

  return(
    <>
      <div className = "postingsList">
        {postings.map(posting => <PostingCard key = {posting.id} posting = {posting} setActivePosting = {setActivePosting} active = {posting === activePosting} />)}
      </div>
      <PostingDetails posting = {activePosting} handleModifyPosting = {handleModifyPosting} setActivePosting = {setActivePosting}/>
    </>
  )
}

export default PostingsContainer