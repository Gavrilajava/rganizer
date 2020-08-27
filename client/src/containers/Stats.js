import React, {useState, useEffect} from 'react'
import {API_ROOT} from '../constants/api'


const Stats = props => {

  const [stats, setStats] = useState({})

  useEffect(() => {
    fetch(API_ROOT + "/stats")
      .then(resp => resp.json())
      .then(json => setStats(json))
  }, [])

  return (
    <ol>
      <li>Postings applied: {stats.applied}</li><br></br>
      <li>Companies applied: {stats.companies}</li><br></br>
      <li>Unrelevant Postings: {stats.unrelevant}</li><br></br>
      <li>New Postings: {stats.new}</li><br></br>
      <li>Expired: {stats.expired}</li><br></br>
    </ol>
  )

}

export default Stats