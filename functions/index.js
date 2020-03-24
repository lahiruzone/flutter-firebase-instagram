const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onFollowUser = functions.firestore
    .document('/followers/{userId}/userFollowers/{followerId}')
    .onCreate(async (snapshot, context) => {
        console.log(snapshot.data());
        const userId = context.params.userId;
        const followerId = context.params.followerId;
        const followedUserPostRef = admin.firestore().collection('posts').doc(userId).collection('usersPost');
        const userFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed');
        const followedUserPostsSnapshot = await followedUserPostRef.get();
        followedUserPostsSnapshot.forEach((doc) => {
            if (doc.exists) {
                userFeedRef.doc(doc.id).set(doc.data());
            }
        });
    });

exports.unFollowUser = functions.firestore
    .document('/followers/{userId}/userFollowers/{followerId}')
    .onDelete(async (snapshot, context) => {
        console.log(snapshot.data());
        const userId = context.params.userId;
        const followerId = context.params.followerId;
        const userFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed').where('authorId', '==', userId);
        const userPostSnapshot = await userFeedRef.get();
        userPostSnapshot.forEach((doc) => {
            if (doc.exists) {
                doc.ref.delete();
            }
        });

    });

exports.onUploadPost = functions.firestore
    .document('/posts/{userId}/usersPost/{postId}')
    .onCreate(async (snapshot, context) => {
        const userId = context.params.userId;
        const postId = context.params.postId;
        const userFollowerListRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');
        const userFollowersSnapshot = await userFollowerListRef.get();
        userFollowersSnapshot.forEach((doc) => {
            if (doc.exists) {
                admin.firestore().collection('feeds').doc(doc.id).collection('userFeed').doc(postId).set(snapshot.data());
            }

        });
    });
