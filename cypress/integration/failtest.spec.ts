describe('My First Test', () => {
  it('Visits the initial project page', () => {
    cy.visit('/');
    cy.contains('Unicomer');
    cy.contains('Unicomer app is running!');
  });
});
