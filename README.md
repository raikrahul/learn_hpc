# Learn HPC Lessons

Welcome to the repository for **Learn HPC Lessons** - a website dedicated to providing clear, text-based tutorials on High-Performance Computing (HPC) concepts.

This site is built using Jekyll and hosted on GitHub Pages, making it easy to contribute lessons and automatically deploy updates.

## Features

*   **Automatic Lesson Listing:** New lessons added to the `_posts` directory are automatically listed on the homepage.
*   **Markdown Content:** Lessons are written in Markdown, a simple and readable format.
*   **Consistent Layout:** The site uses a Jekyll layout for a consistent look and feel across all lessons.
*   **GitHub Pages Deployment:**  The site is automatically built and deployed using GitHub Pages whenever changes are pushed to the `main` branch.

## How to Add New Lessons

Adding a new lesson is straightforward! Just follow these steps:

1.  **Create a New Markdown File in the `_posts` Directory:**
    *   Navigate to the `_posts` folder in this repository.
    *   Create a new file named using the following format: `YYYY-MM-DD-lesson-title.md`
        *   `YYYY-MM-DD`:  Use the date you are creating the lesson (e.g., `2025-03-04`).
        *   `lesson-title`:  A short, descriptive title for your lesson, using hyphens (-) instead of spaces and keeping it lowercase (e.g., `lesson2-parallel-computing-basics`).
        *   Example filename: `2025-03-04-lesson2-parallel-computing-basics.md`

2.  **Add Front Matter to the Top of Your Lesson File:**
    *   At the very beginning of your new Markdown file, add the following "front matter" block, enclosed by `---` lines:

        ```markdown
        ---
        layout: default
        title: "Lesson 2: Basics of Parallel Computing"  # The title of your lesson (will be displayed on the page)
        date: 2025-03-04 # The date of the lesson
        categories: hpc, basics # (Optional) Categories for your lesson
        permalink: /lesson2/ # (Optional) Custom URL for the lesson
        ---
        ```
        *   **Customize:**
            *   `title`:  Change this to the actual title of your lesson.
            *   `date`:  Update this to the date you are creating the lesson.
            *   `categories` and `permalink` are optional but can be helpful for organization and custom URLs.

3.  **Write Your Lesson Content in Markdown:**
    *   Below the closing `---` of the front matter, start writing your lesson content using Markdown syntax. You can use headings, paragraphs, lists, code blocks, images, and more.

        ```markdown
        ---
        layout: default
        title: "Lesson 2: Basics of Parallel Computing"
        date: 2025-03-04
        ---

        ## Introduction to Parallel Computing

        [Your lesson content in Markdown format starts here...]

        ### Why Parallel Computing?

        [Continue writing your lesson...]
        ```

4.  **Commit and Push Your New Lesson File:**
    *   Save your new Markdown file in the `_posts` directory.
    *   Commit your changes to your Git repository.
    *   Push your commit to the `main` branch on GitHub.

5.  **Wait for Automatic Deployment:**
    *   GitHub Actions will automatically build and deploy your site within a few minutes whenever you push to the `main` branch.
    *   You can check the progress in the "Actions" tab of your repository.

6.  **Verify Your Lesson is Live:**
    *   Once the GitHub Actions workflow succeeds, visit your website at [https://raikrahul.github.io/learn_hpc/](https://raikrahul.github.io/learn_hpc/).
    *   Your new lesson should now be listed on the homepage under the "Lessons" section.
    *   Click on the lesson link to view the full lesson content.

## Basic Setup (For Local Development - Optional)

While you can contribute lessons directly by editing files on GitHub, if you want to preview changes locally before pushing, you can set up Jekyll on your computer:

1.  **Install Ruby and Bundler:** Jekyll is built with Ruby. Follow the Jekyll [installation guide](https://jekyllrb.com/docs/installation/) for your operating system to install Ruby and Bundler.

2.  **Install Jekyll Dependencies:**
    *   In your repository's root directory, run: `bundle install`

3.  **Run Jekyll Locally:**
    *   To build and serve the site locally, run: `bundle exec jekyll serve`
    *   Open your browser and go to `http://localhost:4000` to view your site.

## Customization

You can customize the appearance and settings of your site by:

*   **Editing `_config.yml`:**  Change the site title, description, theme, and other site-wide settings in the `_config.yml` file.
*   **Modifying `assets/css/style.css`:** Customize the CSS in `assets/css/style.css` to change the visual style of your website.
*   **Exploring Jekyll Themes:** You can change the overall look of your site by using a different Jekyll theme.  See [jekyllthemes.io](https://jekyllthemes.io/) for a directory of themes.

## License

This project is open-source and available under the [MIT License](LICENSE).

## Live Site

[https://raikrahul.github.io/learn_hpc/](https://raikrahul.github.io/learn_hpc/)

## Contributing

[Optional: Add information about how others can contribute to the project, e.g., reporting issues, suggesting improvements, contributing lessons, etc.]

---

**That's it!**  Happy lesson creating and sharing!
