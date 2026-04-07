class EndPoint {
  //Base url
  static const baseurl = "https://apisocialbook.veteransoftwares.com/api";
  // auth

  static const login = "/Login/auth/login";
  static const refresh = "/Login/auth/refresh";
  static const sendOTP = "/Auth/send-otp";
  static const signup = "/Registration/CreateUser";
  static const profileRegister = "/Profile/ProfileRegister";
  static const signupOTPVerification = "/Registration/VerifyOtp";
  static const profilesStatus = "/Profile/profiles/status";
  static const userAddFriendSearch = "/search-profiles/Search";
  static const getFriendRequest = "/Connections/friend-requests";

  static const fetchProfile = "/Profile/user";
  static const fetchProfileOtherUser = "/OtherProfile";
  static const userProfile = "/Profile";
  static const sendRequest = "/Connections/SendRequest";
  static const espondToRequest = "/Connections/RespondToRequest";
  static const rejectFriendRequestBySender =
      "/Connections/RespondToRequestBySender";
  static const getFriends = "/Connections/friends";
  static const getPost = "/Post/search";
  static const getMyPost = "/Post/my-posts";
  static const createMyPost = "/Post/create";
  static const reels = "/Reel/SearchReels";
  static const like = "/Reactions/Add";
  static const postWithComments = "/Comments/post-with-comments";
  static const commentsCreate = "/Comment/create";
  static const ecommerceCategories = "/Ecommerce/categories";
  static const ecommerceProducts = "/Ecommerce/products";
  static const ecommerceProductDetails = "/Ecommerce/product_Details";
  static const ecommerceAddToCart = "/Ecommerce/add-to-cart";
  static const ecommerceShowCart = "/Ecommerce/show-cart-total";
  static const ecommerceAddress = "/ShippingAddress/list";
  static const ecommerceAdAddress = "/ShippingAddress/add";
  static const ecommerceAddressDelete = "/ShippingAddress/delete";
  static const ecommerceUpdateAddress = "/ShippingAddress/update";
  static const ecommercePlaceOrder = "/Ecommerce/place-order";
  static const ecommerceUpdate = "/Ecommerce/update-payment-status";
  static const ecommerceQtyUpdate = "/Ecommerce/update-quantity";
  static const ecommerceDeleteItem = "/Ecommerce/delete-cart-item";
  static const ecommerceUpdatePayment = "/Ecommerce/update-payment-status";
  static const ecommerceOrder = "/Ecommerce/orders";
  static const editProfile = "/UpdateProfile/update";
  static const searchStory = "/Story/SearchStory";
  static const editProfilePicture = "/UpdateProfile/UpdateProfilePicture";
  static const updateCoverImage = "/UpdateProfile/UpdateCoverImage";
  static const commentDelete = "/Comment/Delete";
}
