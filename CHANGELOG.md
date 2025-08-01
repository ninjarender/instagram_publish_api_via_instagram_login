## [Unreleased]

## [0.1.1] - 2025-01-26

### Enhanced
- **Media Container Status Handling** - Improved error handling for media container status monitoring
  - Added comprehensive status checking for all Instagram media container states
  - Added proper error handling for EXPIRED containers (24-hour expiration)
  - Added error handling for ERROR status (failed publishing process)
  - Added error handling for PUBLISHED status (already published containers)
  - Enhanced status monitoring with detailed error messages
  - Maintained existing functionality for FINISHED and IN_PROGRESS statuses

### Improved
- **Code Quality** - Minor code style improvements for better readability

## [0.1.0] - 2025-07-31

### Added

#### Core Architecture
- **Authenticator class** - OAuth authentication with Instagram Basic Display API
  - Exchange authorization code for access token
  - Support for client credentials and redirect URI configuration

- **Publisher class** - Complete media publishing functionality
  - Single image publishing with optional captions
  - Single video publishing (MP4, MOV) with optional captions
  - Carousel publishing (multiple images) with optional captions
  - Support for Instagram Reels and Stories
  - Automatic media container creation and status monitoring
  - Built-in waiting mechanism for media processing completion

- **UserDetails class** - User information and token management
  - Retrieve user profile information with customizable fields
  - Get long-lived access tokens (60-day validity)
  - Refresh existing access tokens (extend for another 60 days)

- **BaseClient superclass** - Shared functionality for token-based classes
  - Common constants (INSTAGRAM_GRAPH_API_ENDPOINT, GRAPH_API_VERSION)
  - Standardized initialization with access_token parameter
  - Inheritance support for consistent API design

- **ApiHelper module** - Centralized HTTP request handling
  - Faraday wrapper with automatic error handling
  - JSON and form-encoded request support
  - Unified Instagram API error parsing and exception raising
  - Configurable headers and parameters

#### Features
- **Caption Support** - Add text descriptions, hashtags, emojis, and mentions to all post types
- **Token Lifecycle Management** - Complete OAuth flow from short-lived to long-lived tokens
- **Error Handling** - Comprehensive error handling for HTTP, JSON, and Instagram API errors
- **Clean Architecture** - SOLID principles with separation of concerns
- **Modular Design** - Independent classes that can be used separately or together

#### Media Type Support
- **IMAGE** - JPEG, PNG images with captions
- **VIDEO** - MP4, MOV videos with captions  
- **REELS** - Instagram Reels with captions
- **STORIES** - Instagram Stories with captions
- **CAROUSEL** - Multiple images in single post with captions

#### Developer Experience
- **Comprehensive Documentation** - Detailed README with usage examples
- **Ruby 3.0+ Support** - Modern Ruby version compatibility
- **MIT License** - Open source friendly licensing
- **RubyGems Ready** - Proper gemspec configuration for easy installation

### Technical Details
- **Dependencies**: faraday (~> 2.0), json (~> 2.0)
- **Development Dependencies**: rake, rspec, rubocop
- **Minimum Ruby Version**: 3.0.0
- **Instagram Graph API Version**: v23.0

### Limitations
- Carousel posts currently support images only (mixed media support planned for future versions)
