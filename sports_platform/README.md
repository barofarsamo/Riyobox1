# RIYOBOX Sports Streaming Platform

A high-performance, scalable, and low-bandwidth sports streaming system built with a multi-language microservices architecture.

## Architecture Overview

```text
                                [ CLIENTS ]
                         (Flutter Mobile, Web App)
                                    |
          +-------------------------+-------------------------+
          |                         |                         |
    [ GO BACKEND ] <-----> [ REDIS CACHE ] <-----> [ SQLITE (Local) ]
    (REST/WebSockets)         (Live Data)           (Persistent UI)
          |
    +-----+--------------------+--------------------+
    |                          |                    |
[ C++ ENGINE ]           [ RUST ANALYTICS ]    [ JAVA PAYMENT ]
(FFmpeg / HLS)           (AI Predictions)      (Subscriptions)
    |                          |                    |
[ CDN / EDGE ]           [ NODE.JS CHAT ]      [ MONGODB / DB ]
```

## System Components

### 1. Flutter Mobile App (`lib/`)
- **Performance**: Integrated `sqflite` for local caching with TTL-based expiration.
- **Optimization**: WebP thumbnail support and lazy loading of details/stats.
- **Real-time**: WebSocket integration for sub-second live match updates.
- **UX**: Dark mode, shimmer loading, and interactive goal alerts.

### 2. Go API Gateway (`sports_platform/api_go/`)
- **Gateway**: Primary entry point for all sports data.
- **Speed**: Optimized with Gin framework, Gzip compression, and Redis caching.
- **Concurrency**: Designed to handle 50,000+ concurrent connections via lightweight Goroutines.

### 3. C++ Video Engine (`sports_platform/video_engine_cpp/`)
- **Processing**: FFmpeg-powered pipeline for adaptive bitrate (ABR) transcoding.
- **Efficiency**: Hardware acceleration (VAAPI/NVENC) for low CPU usage.
- **Streaming**: HLS output with short 4-6s segments for low-latency delivery.

### 4. Rust Analytics Microservice (`sports_platform/analytics_rust/`)
- **Intelligence**: Heavy computation engine for processing real-time stats (xG, Win Prob).
- **Safety**: Memory-safe implementation ensuring 99.99% uptime during peak loads.

### 5. Java/Kotlin Subscription Service (`sports_platform/payment_java/`)
- **Business**: Enterprise-grade service for user subscriptions and payment orchestration.
- **Security**: Robust user management and access control.

### 6. Node.js Chat & Notifications (`sports_platform/chat_node/`)
- **Interaction**: Socket.io powered live fan chat rooms for every match.
- **Messaging**: Automated live commentary feed and push notification dispatch.

## Performance Tuning

1. **Bandwidth Optimization**:
   - Payloads are minified and compressed (Gzip/Brotli).
   - Images are served in WebP format with appropriate resizing.
   - Lazy loading prevents unnecessary data transfer for off-screen components.

2. **Scaling**:
   - Each microservice is containerized (Docker) and ready for Kubernetes (K8s) orchestration.
   - Redis offloads the database by caching frequently accessed fixtures and live scores.

3. **Latency**:
   - WebSocket protocol used for live matches to eliminate polling overhead.
   - C++ engine optimizes the HLS packaging for the fastest possible 'Time to First Frame'.

## Folder Structure

```
riyobox/
├── lib/                        # Enhanced Flutter Codebase
├── backend/                    # Original Node.js Backend
├── sports_platform/            # New Microservices Ecosystem
│   ├── api_go/                 # REST & WS Sports API
│   ├── video_engine_cpp/       # FFmpeg Transcoding Engine
│   ├── analytics_rust/         # AI & Stats Microservice
│   ├── payment_java/           # Subscription & User Service
│   └── chat_node/              # Real-time Chat Service
└── README.md                   # Global Documentation
```

## Setup Instructions

### Go API
```bash
cd sports_platform/api_go
go mod tidy
go run main.go
```

### Node.js Chat
```bash
cd sports_platform/chat_node
npm install
node index.js
```

### Flutter App
```bash
flutter pub get
flutter run
```

---
**GOAL**: Ultra-fast, Low-bandwidth, Scalable, Professional Sports Streaming.
