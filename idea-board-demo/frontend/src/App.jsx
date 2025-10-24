import React, { useEffect, useState } from 'react';
import axios from 'axios';

// Use localhost:8000 for backend API
const API_URL = import.meta.env.VITE_API_URL;


export default function App() {
  const [ideas, setIdeas] = useState([]);
  const [content, setContent] = useState("");

  const fetchIdeas = async () => {
    try {
      const res = await axios.get(`${API_URL}/api/ideas`);
      setIdeas(res.data);
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => { fetchIdeas(); }, []);

  const submit = async (e) => {
    e.preventDefault();
    if (!content) return;
    try {
      await axios.post(`${API_URL}/api/ideas`, { content });
      setContent('');
      fetchIdeas();
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <div style={{ padding: 20, fontFamily: 'Arial, sans-serif' }}>
      <h1>Idea Board</h1>
      <form onSubmit={submit} style={{ marginBottom: 20 }}>
        <input
          value={content}
          onChange={e => setContent(e.target.value)}
          placeholder="Your idea"
          style={{ padding: 8, width: 300 }}
        />
        <button type="submit" style={{ marginLeft: 8, padding: '8px 12px' }}>
          Add
        </button>
      </form>
      <ul>
        {ideas.map(i => (
          <li key={i.id}>
            {i.content} <small style={{ color: '#888' }}>({new Date(i.created_at).toLocaleString()})</small>
          </li>
        ))}
      </ul>
    </div>
  );
}
