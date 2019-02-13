# NetFlux
Completed by: Shahin Zangenehpour

## Comments
This is an iOS app that displays a list of TV shows that a user can see the details of and "favourite" for viewing later. It was done as part of a Codeing Challenge with an un-named potential employer ;) and was completed over a weekend (fewer than 48 hours).

Overall, this was a really cool and educational exercise as I had not done work related to the persistence layer in a long time.

Below, I will provide comments on main architecture decision, list of 3rd party libraries, reflections on code, and additional comments.

### 1. Architectural Decisions

In the spirit of KISS (i.e., "keep it simple, silly"), an MVC design pattern was adopted for this project, complemented by distinct, well-encapsulated service classes for networking, persistence, alerts and web portal (for viewing external web content). The persistence layer (using CoreData) acts as a true cache for content on the client side. Network fetch service (under the current iteration) is triggered _only_ if local stores have no data. This layer can later be modified to perform periodic sync with the remote DB.

The fetched `JSON` is then handed off to the `PersistenceService`, which works in conjunction with the `Show` data model (implementing `Codable` + `NSManagedObject` protocols) to parse and store the downloaded data.

The Views are provided with objects and they end up configuring themselves in the most part independently of the controllers.

### 2. Third Party Libraries

Only **two** third party libraries were used for this project:

- `SDWebImage` was used to *lazyly* download images of shows and load them with a simple and elegant animation into the image views.
- `OHHTTPStubs/Swift` was used to efficiently mock network responses for the purpose of unit testing.

### 3. Reflections on Code

The code could certainly be improved if I had additional time to implement more unit tests to cover other parts of the code base. In addition, I could use some of the additional time to implement automated UI tests to provide additional improvements to code quality and app stability.

I would also spend some of that time to modify my approach to the implementation of the persistence layer. Early on, I interpreted the requirements to be in alignment of what I developed. But earlier today, after re-reading the requirement, I realized that persistence was _only_ required for saved/favourited shows. I know exactly what needs to be done to implement that version of persistence, but in the interest of time, I left it as is because, in effect, it appears to be be doing almost the same thing as the requirements.

Lastly, I would have definitely set up the UI for the project in code as there was a great deal of duplication of code between the two lists. At a minimum, I would have used a single Xib for the two table views and continued using the same controller with modified logic to drive the two screens.

### 4. Additional Comments

Aside from the persistence issue I discussed in the section above, I also noticed that the screen title of the two list views is meant to be left-aligned when large but centre-aligned when shrunk. I managed to discover a native solution which eliminated the use of a 3rd party library and the amount of code used was reduced to **3** essential lines!

I wanted to take this opportunity to thank the AC Engineers and Recruiting team for the hard work of preparing this exercise. I certainly had fun working on it and hope you have fun reading through my work.

All the best,  
Shahin Zangenehpour, PhD
