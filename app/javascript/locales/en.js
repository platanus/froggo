export default {
  message: {
    settings: {
      button: 'Go to dashboard',
      adminUsers: 'Manage Users',
      adminRepos: 'Manage Repositories',
      repoUpdate: 'Last update on',
      sync: 'sync',
      loading: '...loading',
      error: 'There was an error',
      disablePublic: 'Disable public dashboard',
      enablePublic: 'Enable public dashboard',
    },
    profile: {
      noTeams: 'No teams',
      teamsDropdownTitle: 'Teams',
      noOrganizations: 'No organizations',
      organizationsDropdownTitle: 'Organizations',
      recommendedReviewers: 'You should assign your next PR to...',
      notRecommendedReviewers: 'Avoid assigning your next PR to...',
      noTeamsInOrganization: 'You are not member of any organization team so you have no recommendations',
      statistics: {
        obedientCount: 'Obeyed recommendations',
        indifferentCount: 'Ignored recommendations',
        rebelCount: 'Rejected recommendations',
      },
      timespanDropdownTitle: 'Since',
      relationsTitle: 'Your relation with the rest of the team: ',
      badgeExplainer: {
        low: 'Also part of your team! Don\'t ignore them :(',
        midlow: 'Could still receive some love!',
        good: 'Your Froggo objective',
        midhigh: 'Don\'t overdo it...',
        high: 'You seem fixated...',
      },
    },
    admin: {
      noDefaultTeam: 'No default team',
      defaultTeamDropdownTitle: 'Default team',
    },
    froggoTeams: {
      organizationTitle: 'Organization: ',
      belongedTeams: 'Teams I belong to: ',
      notBelongedTeams: 'Other organization teams: ',
      createButton: 'Create Team',
      insertTeamName: 'Team Name: ',
      addMember: 'Add members: ',
      editName: 'Edit name',
      saveName: 'Save name',
      members: 'Members: ',
      deleteFromTeam: 'Delete member',
      saveChanges: 'Save changes',
      editTeam: 'Edit Team',
      deleteTeam: 'Delete team',
      successfullySavedChanges: 'Changes were successfully saved',
      successfullyCreatedTeam: 'Team was successfully created',
      percentageDropdownTitle: 'PRs assignation',
      increasePercentageMessage: 'If you are going to increase the assignation % remember to do it progressively',
    },
    prFeed: {
      noName: 'Unknown',
      prName: 'Pull Request',
      prAuthor: 'Author',
      prProject: 'Project',
      prTitle: 'Title',
      prTime: 'Time',
      prDate: 'Date',
      prDescription: 'Description',
      prCommits: 'Commits',
      prUnknown: '---',
      prReviewers: 'Reviewers',
      prGoToGithub: 'Go to Github',
      prSee: 'See',
      prCreated: 'Created by',
      prThe: 'the',
      prStartDate: 'From',
      prEndDate: 'Until',
    },
    error: {
      unauthorized: 'Permission denied',
      existentName: 'Name already exists for an organization team',
    },
    metrics: {
      noPullRequestInformation: 'There\'s no pull requests information',
      metricsTitle: 'Time metrics',
      creationToAssignmentTimeLabel: 'Time between pull request\'s creation and assignment',
      assignmentToResponseTimeLabel: 'Time between pull request\'s assignment and first response',
      responseToApprovalTimeLabel: 'Time between pull request\'s first response and approval',
      approvalToMergeTimeLabel: 'Time between pull request\'s approval and merge',
      bottomSummaryText: 'mean time',
      creationToAssignmentSummaryText: 'PR\'s creation to assignment',
      assignmentToResponseSummaryText: 'PR\'s assignment to response',
      responseToApprovalSummaryText: 'PR\'s response to approval',
      approvalToMergeSummaryText: 'PR\'s approval to merge',
      chartYLabel: 'minutes',
    },
    time: {
      day: 'day',
      hour: 'hour',
      minute: 'minute',
    },
    organization: {
      members: {
        inactiveDays: 'Inactive days: ',
        score: 'Score: ',
      },
    },
  },
};
