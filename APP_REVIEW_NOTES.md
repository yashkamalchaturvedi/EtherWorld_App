# App Review Notes for Guideline 4.2.2 (Minimum Functionality)

Submission target: next resubmission after 1.0 (Build 1)

## Copy/Paste: App Store Connect "Notes for Review"

Hello App Review Team,

Thank you for the previous feedback. We implemented targeted changes so EtherWorld is now clearly a native iOS experience and not a web-browsing wrapper.

### What changed in this build

1. **In-app article navigation policy**
- Article content now uses explicit navigation handling.
- Internal EtherWorld links stay in-app.
- External links open intentionally in Safari.
- This removes silent browser handoffs from core reading flow.

2. **In-app privacy access in login flow**
- The login footer now opens the app's native Privacy Policy screen.
- Users are no longer required to leave the app to read privacy details.

3. **External links are now secondary and clearly labeled**
- Website/social links in Settings are explicit actions and marked as opening Safari.
- Core app navigation remains native.

4. **New native personalization experience (For You feed)**
- Added first-run personalization onboarding.
- Users can select preferred topics and choose feed mode (For You vs Latest).
- Feed ranking updates natively in-app from user selections.
- Preferences can be edited in Settings and are synced to backend preferences.

### Native functionality available during review

- Multi-provider native authentication (Apple, Google, OTP email)
- Saved articles and read-state tracking
- Offline article and image caching
- Native push notification preferences and quiet hours
- Native search/discovery and author navigation
- Native settings/profile/privacy screens

## Reviewer Test Path (Fast)

1. Launch app.
2. Login using Apple/Google/Email OTP.
3. Personalization onboarding appears: choose topics and continue.
4. Home feed shows **For You** state.
5. Open an article, tap an internal link (stays in-app).
6. Tap an external link (opens Safari intentionally).
7. Open Settings -> Personalization and change topics.
8. Return to Home and confirm feed reflects changes.
9. Open Settings -> Privacy Policy (in-app view).

## Internal Pre-Submission Checklist

- [ ] Verify For You onboarding appears on fresh install.
- [ ] Verify For You vs Latest toggle behavior.
- [ ] Verify internal vs external article links behavior.
- [ ] Verify login privacy link opens in-app policy view.
- [ ] Verify Settings external links are clearly marked.
- [ ] Verify preference sync succeeds with authenticated account.
- [ ] Verify no regressions in Apple/Google/OTP login.
- [ ] Verify offline open of a previously viewed/saved article.

## Optional Short "What's New" Text

- Introduced a native **For You** feed with topic personalization.
- Improved in-app reading flow with clearer link behavior.
- Added easier in-app access to privacy information.
- Refined settings link handling for clearer user navigation.
