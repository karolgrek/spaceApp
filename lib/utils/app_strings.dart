/// Centralized user-facing strings for the Space App.
class AppStrings {
  AppStrings._();

  // APOD Titles & Headings
  static const String apodTitle = "Astronomy Picture of the Day";
  static const String fetchingFromNasa = "Fetching from NASA...";
  static const String connectingToNasa = "Connecting to NASA server...";
  static const String downloadingApod =
      "Downloading Astronomy Picture of the Day";
  static const String exploreTodaysPhoto = "Explore today's NASA photo";
  static const String unableToLoadTapStatus =
      "Unable to load \u2022 Tap to view status";

  // Cache & Offline Messages
  static const String offlineCopyAvailable = "Offline copy available";
  static const String savedOfflineCopyAvailable =
      "Saved Offline Copy Available";
  static const String viewSavedPicture = "View Saved Picture";
  static const String tryConnectingAgain = "Try Connecting Again";
  static const String tryAgain = "Try Again";
  static const String noSavedPictureFound =
      "No previously downloaded picture was found in local storage.";
  static const String offlineMode = "Offline Mode";
  static const String showingSavedPicture = "Showing Saved Picture";
  static const String couldNotConnectToNasaNotice =
      "Could not connect to NASA. You can view the saved picture below.";
  static const String apodUpdatedSuccess =
      "Picture of the Day updated successfully!";
  static const String couldNotRefreshApod =
      "Could not refresh Picture of the Day.";
  static const String retry = "Retry";

  // Content Details
  static const String explanation = "Explanation";
  static const String noExplanation = "No explanation provided.";
  static const String photoBadge = "PHOTO";
  static const String videoBadge = "VIDEO";
  static const String offlineBadge = "OFFLINE";
  static const String tapForInfoBadge = "TAP FOR INFO";
  static const String tapToZoom = "Tap to zoom";
  static const String todaysApodIsVideo = "Today's APOD is a Video";
  static const String copyVideoLink = "Copy video link";
  static const String videoLinkCopied = "Video link copied to clipboard!";
  static const String loadingImagery = "Loading space imagery...";
  static const String videoPreviewUnavailable = "Video preview unavailable";
  static const String couldNotRenderImage = "Could not render image";
  static const String videoThumbnailError =
      "The video thumbnail could not be loaded.";
  static const String imageDownloadError =
      "The media file could not be downloaded from NASA servers.";
  static const String noImagePreviewAvailable = "No image preview available";
  static const String videoOfTheDay = "Video of the Day";
}
