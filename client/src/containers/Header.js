import React from 'react'
import Delete from './Delete'
import Search from './Search'


const Header = () => {
  return(
    <ul className="nav">
      <li className="liNav"><a href="/">Home</a></li>
      <li className="liNav"><a href="/applied">Applied</a></li>
      <li className="liNav"><a href="/locations">Locations</a></li>
      <li className="liNav"><a href="/keywords">Keywords</a></li>
      <li className="liNav"><a href="/stats">Stats</a></li>
      <Delete/>
      <Search/>
    </ul>
  )
}

export default Header