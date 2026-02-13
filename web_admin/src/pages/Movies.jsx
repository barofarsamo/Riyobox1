import React, { useState, useEffect } from 'react';
import api from '../utils/api';

const Movies = () => {
  const [movies, setMovies] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    posterUrl: '',
    videoUrl: ''
  });

  const fetchMovies = async () => {
    setLoading(true);
    try {
      const res = await api.get('/admin/movies');
      setMovies(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMovies();
  }, []);

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this movie?')) return;
    try {
      await api.delete(`/admin/movies/${id}`);
      fetchMovies();
    } catch (err) {
      alert('Delete failed');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await api.post('/admin/movies', formData);
      setIsModalOpen(false);
      setFormData({ title: '', description: '', posterUrl: '', videoUrl: '' });
      fetchMovies();
    } catch (err) {
      alert('Upload failed');
    }
  };

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold">Movies</h1>
          <p className="text-gray-400">Manage your content library.</p>
        </div>
        <button
          onClick={() => setIsModalOpen(true)}
          className="bg-purple-600 hover:bg-purple-700 px-6 py-2 rounded-lg font-bold transition-colors"
        >
          Add New Movie
        </button>
      </div>

      {loading ? (
        <div className="text-center py-20 text-gray-500 italic">Loading content...</div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {movies.map((movie) => (
            <div key={movie._id} className="bg-[#1C1C1C] rounded-xl overflow-hidden border border-white/5 group">
              <div className="h-48 overflow-hidden relative">
                <img
                  src={movie.posterUrl}
                  alt={movie.title}
                  className="w-full h-full object-cover transition-transform group-hover:scale-105"
                  onError={(e) => { e.target.src = 'https://via.placeholder.com/300x450?text=No+Image' }}
                />
                <div className="absolute top-2 right-2 flex space-x-2">
                   <button
                    onClick={() => handleDelete(movie._id)}
                    className="p-2 bg-red-600 rounded-full hover:bg-red-700 shadow-lg"
                   >
                    🗑️
                   </button>
                </div>
              </div>
              <div className="p-5">
                <h3 className="text-lg font-bold truncate">{movie.title}</h3>
                <p className="text-gray-500 text-sm mt-1 line-clamp-2">{movie.description}</p>
                <div className="mt-4 pt-4 border-t border-white/5 flex items-center text-xs text-gray-400 italic">
                  URL: {movie.videoUrl.substring(0, 30)}...
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Upload Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4 z-50">
          <div className="bg-[#1C1C1C] max-w-lg w-full rounded-2xl border border-white/10 shadow-2xl overflow-hidden">
            <div className="p-6 border-b border-white/5 flex justify-between items-center">
              <h2 className="text-xl font-bold">Upload New Content</h2>
              <button onClick={() => setIsModalOpen(false)} className="text-gray-500 hover:text-white">✕</button>
            </div>
            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-400 mb-1">Movie Title</label>
                <input
                  required
                  className="w-full bg-[#262626] border border-white/10 rounded px-4 py-2 focus:outline-none focus:border-purple-500"
                  value={formData.title}
                  onChange={(e) => setFormData({...formData, title: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-400 mb-1">Description</label>
                <textarea
                  required
                  rows="3"
                  className="w-full bg-[#262626] border border-white/10 rounded px-4 py-2 focus:outline-none focus:border-purple-500"
                  value={formData.description}
                  onChange={(e) => setFormData({...formData, description: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-400 mb-1">Poster Image URL</label>
                <input
                  required
                  className="w-full bg-[#262626] border border-white/10 rounded px-4 py-2 focus:outline-none focus:border-purple-500"
                  value={formData.posterUrl}
                  onChange={(e) => setFormData({...formData, posterUrl: e.target.value})}
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-400 mb-1">Direct Video URL</label>
                <input
                  required
                  className="w-full bg-[#262626] border border-white/10 rounded px-4 py-2 focus:outline-none focus:border-purple-500"
                  value={formData.videoUrl}
                  onChange={(e) => setFormData({...formData, videoUrl: e.target.value})}
                />
              </div>
              <div className="pt-4">
                <button
                  type="submit"
                  className="w-full bg-purple-600 hover:bg-purple-700 py-3 rounded-lg font-bold transition-all"
                >
                  Confirm Upload
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Movies;
